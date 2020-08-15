class OrderMailer < ApplicationMailer
  default from: 'Украинский мясокомбинат'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @order = order

    mail to: "malakhovua@outlook.com", subject: 'Украинмкий мясокомбинат'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order

    mail to: "malakhovua@outlook.com", subject: 'Украинмкий мясокомбинат. Доставка'
  end
end
