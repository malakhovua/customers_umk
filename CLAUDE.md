# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

- Ruby 2.6.5, Rails 5.2.4
- PostgreSQL (development/production), SQLite (test)
- CoffeeScript + Bootstrap 4 + jQuery for frontend
- `whenever` gem for cron jobs (not ActiveJob/Sidekiq)

## Commands

```bash
# Start dev environment (recommended — includes DB and cron)
docker-compose up

# Run Rails server standalone
bundle exec rails s

# Run all tests (MiniTest)
bundle exec rails test

# Run a single test file
bundle exec rails test test/models/order_test.rb

# Lint
bundle exec rubocop

# Database
bundle exec rails db:migrate
bundle exec rails db:schema:load

# Regenerate crontab from config/schedule.rb
bundle exec whenever --update-crontab
```

## Architecture

This is a **B2B wholesale ordering platform** (UI is in Ukrainian) that acts as a frontend for a **1C:UNF** accounting/ERP system. All product catalog, client, and pricing data originates in 1C and is synced into this app; orders placed here are pushed back to 1C.

### 1C Integration (`app/jobs/unf.rb`)

`Unf` is a plain Ruby class (not an ActiveJob) that owns all communication with the 1C server via Faraday HTTP. The 1C server URL and credentials path are stored in the `exch_nodes` table (always uses the first record).

Key methods:
- `get_all_data` — full sync: access groups, price types, clients, addresses, products, packs, prices, product exceptions
- `get_expense_invoices` — syncs expense invoices (расходные накладные)
- `get_regular_prices` — syncs prices only for `Pricetype` records with `update_regularly: true`
- `post_orders` — pushes orders with `server_unf: nil` to 1C; on success, 1C returns `server_unf`/`server_unf_date` to mark the order as received

After each successful sync, `delete_registration` is called with a numeric type code to acknowledge receipt on the 1C side.

`AdminController` exposes each sync method as a manual trigger via `GET /admin/*_1c83` routes. The `config/schedule.rb` cron runs the same methods automatically (post orders every 5 min, full sync every 30 min, regular prices every 60 min, invoices every 10 min).

### Domain Model

**Users & Access Control**
- `User` — roles: `admin`, `user`, `retailer` (enum). Belongs to `AccessGroup`, optionally to a `Pricetype` and `StoragePlace`.
- `Client` — the buying company, synced from 1C. Belongs to `AccessGroup` and optionally a `Pricetype`.
- `AccessGroup` — groups users and clients together. Non-admin users see only clients whose `access_group_id` matches their own.
- `Asighnclient` — join table linking specific users to specific clients they manage (used in the client assignment UI at `/asighnclients`).

**Product Catalog**
- `Product` — hierarchical tree via `parent_id`/`unf_parent_id`. Records with `is_folder: true` are category nodes; `is_folder: false` are orderable products. Active products have `deletion_mark: false` and `not_active: false`.
- `Pack` — a packaging unit for a product (e.g. box of 12). Has its own `Price` records separate from per-unit prices.
- `Unit` / `UnitProduct` — measurement units. `Unit.piece` distinguishes piece-counted items (tracked by `amount`) from weight-based items (tracked by `quantity`). `UnitProduct` is the per-product unit with a `weight` ratio and a `default` flag.
- `ProductExeption` (sic) — restricts a product to specific clients; products appearing here are hidden from other clients.

**Pricing**
`Product.get_price(prod_id, price_type, pack_id, unit_product_id, period, calculate_weight)` is the central pricing method. It finds the most recent `Price` record with `period ≤ given_date` for the given pricetype and unit. If `calculate_weight: true`, divides price by the unit's weight ratio (for kg-based pricing). Pack prices are additive on top of the product price. `Pricetype#ignore_empty_prices` causes the customer view to filter out products that have no current price for that pricetype.

**Cart → Order flow**
1. `Cart` + `LineItem` accumulate items (one cart per session/user). `LineItem` stores both `amount` (piece count) and `quantity` (weight), plus a computed `recount` (total weight).
2. `Order` is created from the cart via `add_line_items_from_cart`, which copies line items and resolves prices at that moment.
3. Placing an order sends an email via `OrderMailer` and destroys the cart.
4. Orders cannot be edited or deleted once `server_unf` is set (already synced to 1C).

**Other models**
- `Inventory` / `InventoryLineItem` — warehouse stock-take records, also exposed via the `v1` JSON API.
- `ExpenseInvoice` / `LineItemExpenseInvoice` — delivery/expense invoices synced from 1C, grouped by `AccessGroup`.
- `StoragePlace` — warehouse storage locations, linked to users and inventory records.
- `FavoriteProduct` — per-client favourites, filterable in the customer view.

### Controllers

- `CustomerController` — main shopping UI. Resolves the active client from session, applies product filters (category tree, name search, favourite, empty-price filter), paginates with Kaminari.
- `AdminController` — requires `admin` role. Manual 1C sync triggers and order export.
- `OrdersController` — order CRUD. Non-admin users see only orders from their `access_group`.
- `SessionsController` — session-based auth (`has_secure_password`, bcrypt). All controllers require login via `ApplicationController#authorize`.
- `V1::ProductsController`, `V1::InventoriesController` — JSON API under `/v1/`, HTTP Basic Auth (`username_api` / hardcoded password).

### Authentication

`ApplicationController#authorize` redirects to `/login` unless `session[:user_id]` resolves to a `User`. `Current.user` (Rails `CurrentAttributes`) is set on every request for use throughout the request lifecycle. Admin-only actions call `ensure_an_admin_role`.
