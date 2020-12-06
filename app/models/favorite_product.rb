class FavoriteProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :client
end
