# frozen_string_literal: true

FactoryBot.define do
  factory :scrap do
    title { 'テストタイトル' }
    content { 'テスト本文' }
    association :user, factory: :user
  end
end
