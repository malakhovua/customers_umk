class Asighnclient < ApplicationRecord
  belongs_to :user
  belongs_to :client
  paginates_per 50
  max_paginates_per 100
end
