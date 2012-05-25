class Tournament < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :user
  validates :name, presence: true, length: { maximum: 50}, uniqueness: { case_sensitive: false }
  validates :description, presence:true, length: {maximum: 100 }
  validates :user_id, presence: true
end
