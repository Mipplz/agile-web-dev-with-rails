class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: true

  after_destroy :ensure_an_admin_remains

  class DeleteError < StandardError
  end

  private

  def ensure_an_admin_remains
    raise DeleteError, "Can't delete last user" if User.count.zero?
  end
end
