# frozen_string_literal: true

class User < ApplicationRecord
  has_many :scraps, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_scraps, through: :bookmarks, source: :scrap

  has_many :active_relationships, class_name: 'Relationship', foreign_key: :following_id
  has_many :followings, through: :active_relationships, source: :follower

  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :followers, through: :passive_relationships, source: :following
  # =======================================================================================
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true, length: { maximum: 20 }

  def owns?(resource)
    id == resource.user_id
  end

  def bookmark?(resource)
    bookmark_scraps.include?(resource)
  end

  def bookmark(resource)
    bookmark_scraps << resource
  end

  def unbookmark(resource)
    bookmark_scraps.destroy(resource)
  end

  def follow?(resource)
    followings.include?(resource)
  end

  def follow(resource)
    followings << resource
  end

  def unfollow(resource)
    followings.destroy(resource)
  end
end
