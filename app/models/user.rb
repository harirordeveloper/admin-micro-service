class User < ApplicationRecord
  include EmployeeSync
  has_secure_password
  self.inheritance_column = :type

  validates :email, presence: true, uniqueness: true
  before_validation :ensure_jti_is_set

  def revoke_jwt
    update_column(:jti, generate_jti)
  end

  private

    def generate_jti
      SecureRandom.uuid
    end

    def ensure_jti_is_set
      self.jti = generate_jti
    end
end