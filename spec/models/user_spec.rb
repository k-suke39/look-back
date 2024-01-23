# frozen_string_literal: true

require 'rails_helper'

describe User do
  let(:nickname) { 'テスト太郎' }
  let(:email) { 'test@example.com' }
  let(:password) { '11111111' }
  let(:user) { build(:user, nickname:, email:, password:, password_confirmation: password) }

  describe '.first' do
    before do
      @user = create(:user, nickname:, email:)
      @post = create(:scrap, title: 'タイトル', content: '本文', user_id: @user.id)
    end

    subject { described_class.first }

    it '作成したUserを返す' do
      expect(subject.nickname).to eq(nickname)
      expect(subject.email).to eq(email)
    end

    it '紐づくPostの情報を取得できる' do
      expect(subject.scraps.first.title).to eq('タイトル')
      expect(subject.scraps.first.content).to eq('本文')
      expect(subject.scraps.first.user_id).to eq(@user.id)
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
            expect(user.errors[:nickname]).to include('が入力されていません。')
          end
        end
      end
    end
  end

  describe '#owns?' do
    let(:user) { create(:user) }
    let(:scrap) { create(:scrap, user: user) }
    let(:other_user) { create(:user) }
    context 'ユーザのScrapである場合' do
      it 'trueを返す' do
        expect(user.owns?(scrap)).to be true
      end
    end
    context 'ユーザのScrapではない場合' do
      it 'ユーザがリソースを所有していない場合はfalseを返す' do
        expect(other_user.owns?(scrap)).to be false
      end
    end
  end
end
