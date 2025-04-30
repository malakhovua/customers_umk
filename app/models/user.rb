class User < ApplicationRecord

  enum role: %i[admin user retailer]
  has_many :orders
  has_many :inventories
  has_many :asighnclients
  has_many :clients, through: :asighnclients
  belongs_to :access_group, optional: true
  belongs_to :inventory, optional: true
  belongs_to :storage_place, optional: true
  validates :name, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_an_admin_remains

  def self.current_user
    Current.user
  end

  def admin?
    role == 'admin'
  end

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end

end
