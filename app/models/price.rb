class Price < ApplicationRecord
  belongs_to :pricetype
  belongs_to :pack, class_name: "Pack", foreign_key: :pack_id,optional: true
  belongs_to :product
end
