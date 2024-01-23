# frozen_string_literal: true

require 'rails_helper'

describe User do
  let(:nickname) { 'テスト太郎' }
  let(:email) { 'test@example.com' }
  let(:password) { '11111111' }
  let(:user) { build(:user, nickname:, email:, password:, password_confirmation: password) }

  describe '.first' do
    before do
      create(:user, nickname:, email:)
    end

    subject { described_class.first }
    it '作成したUserを返す' do
      expect(subject.nickname).to eq(nickname)
      expect(subject.email).to eq(email)
    end
  end

  describe 'validation' do
    describe 'nickname' do
      context '正常系' do
        context 'nicknameが20文字以下の場合' do
          let(:nickname) { 'a' * 20 }
          it 'Userオブジェクトは有効である' do
            expect(user.valid?).to be(true)
          end
        end
      end
      context '異常系' do
        context 'nicknameが21文字以上の場合' do
          let(:nickname) { 'a' * 21 }
          it 'Userオブジェクトは無効である' do
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include('は20文字以下に設定して下さい。')
          end
        end

        context 'nicknameが空欄の場合' do
          let(:nickname) { ' ' }
          it 'Userオブジェクトは無効である' do
            expect(user.valid?).to be(false)
            expect(user.errors[:nickname]).to include("が入力されていません。")
          end
        end
      end
    end
  end
end
