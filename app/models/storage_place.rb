class StoragePlace < ApplicationRecord
  has_many :inventory
  has_many :user
  def params_json_to_object(dat)
    self.unf_id = dat['storage_place_unf_id']
    self.title = dat['storage_place_unf_title']
  end
end
