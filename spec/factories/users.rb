# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    nickname { '山田太郎' }
    sequence :email do |n|
      "test#{n}@example.com"
    end
    password { '111111' }
    password_confirmation { '111111' }
  end
end
