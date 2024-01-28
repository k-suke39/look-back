# frozen_string_literal: true

class User < ApplicationRecord
  has_many :scraps, dependent: :destroy
  has_many :comments, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :nickname, presence: true, length: { maximum: 20 }

  def owns?(resource)
    id == resource.user_id
  end
end
