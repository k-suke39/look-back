# frozen_string_literal: true

require 'rails_helper'

describe Scrap, type: :model do
  before { @user = create(:user) }

  let(:title) { 'テストタイトル' }
  let(:content) { 'テスト本文' }
  let(:user_id) { @user.id }

  describe 'バリデーション' do
    let(:scrap) { build(:scrap, title: title, content: content, user_id: user_id) }

    context '正常系' do
      it 'データが有効である' do
        expect(scrap.valid?).to be(true)
      end     
    end
    context '異常系' do
      context 'titleが空の場合' do
        let(:title) { '' }
        it '無効である' do
          expect(scrap.valid?).to be(false)
          expect(scrap.errors[:title]).to include('が入力されていません。')
        end
      end
      context 'titleが101文字以上の場合' do
        let(:title) { 'a' * 101 }
        it '無効である' do
          expect(scrap.valid?).to be(false)
        end
      end
      context 'contentが空の場合' do
        let(:content) { '' }
        it '無効である' do
          expect(scrap.valid?).to be(false)
          expect(scrap.errors[:content]).to include('が入力されていません。')
        end
      end
      context 'contentが1001文字以上の場合' do
        let(:content) { 'a' * 1001 }
        it '無効である' do
          expect(scrap.valid?).to be(false)
        end
      end
      context 'user_idが空の場合' do
        let(:user_id) { '' }
        it '無効である' do
          expect(scrap.valid?).to be(false)
          expect(scrap.errors[:user]).to include('が入力されていません。')
        end
      end
    end
  end

  describe 'データの検証' do
    before { create(:scrap, title: title, content: content, user_id: user_id) }

    subject { described_class.first }

    it 'scrapの属性値を返す' do
      expect( subject.title ).to eq('テストタイトル')
      expect( subject.content ).to eq('テスト本文')
      expect( subject.user_id ).to eq(@user.id)
    end
  end
end
