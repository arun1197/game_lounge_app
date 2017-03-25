class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  default_scope -> { order(created_at: :desc) }
  validates :user, presence: true
  validates :post, presence: true
  validates :content, presence: true, length: { maximum: 200 }
end
