class Gallery < ApplicationRecord
  belongs_to :user
  has_many_attached :pics
  validates_presence_of :title
  has_many :comments, dependent: :destroy

end
