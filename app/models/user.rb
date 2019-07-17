class User < ApplicationRecord
    has_secure_password
    after_initialize :set_defaults, unless: :persisted?
  # The set_defaults will only work if the object is new
  has_many :galleries, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :pins, dependent: :destroy
  def set_defaults
    self.isAdmin = false
  end
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
    validates_presence_of :name
end
