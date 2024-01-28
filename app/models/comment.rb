# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :scrap

  validates :content, presence: true, length: { maximum: 255 }
end
