class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :gallery
  validates_presence_of :comment

end
