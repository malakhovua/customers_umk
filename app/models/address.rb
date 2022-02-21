class Address < ApplicationRecord
  belongs_to :client
  has_many :orders
end
