class Gallery < ApplicationRecord
  belongs_to :user
  has_one_attached :pics
end
