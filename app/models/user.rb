# frozen_string_literal: true

class User < ApplicationRecord
  has_many :scraps, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_scraps, through: :bookmarks, source: :scrap
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true, length: { maximum: 20 }

  def owns?(resource)
    self.id == resource.user_id
  end

  def bookmark?(resource)
    self.bookmark_scraps.include?(resource)
  end

  def bookmark(resource)
    self.bookmark_scraps << resource
  end

  def unbookmark(resource)
    self.bookmark_scraps.destroy(resource)
  end
end
