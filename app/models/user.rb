class User < ApplicationRecord

  enum role: [:admin, :user]
  has_many :orders
  has_many :asighnclients
  has_many :clients, through: :asighnclients
  belongs_to :access_group, optional: true
  validates :name, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_an_admin_remains

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
    end
  end

end
