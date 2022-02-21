class AccessGroup < ApplicationRecord
  has_many :clients
  has_many :users
end
