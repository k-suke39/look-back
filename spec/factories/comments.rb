# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'テストコメント' }
    association :user, factory: :user
    association :scrap, factory: :scrap
  end
end
