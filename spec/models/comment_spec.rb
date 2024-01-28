# frozen_string_literal: true

require 'rails_helper'

describe Comment, type: :model do
  describe 'バリデーション' do
    let(:content) { 'テストコメント' }
    let(:comment) { build(:comment, content:) }

    context '正常系' do
      it 'データが有効である' do
        expect(comment.valid?).to be(true)
      end
    end
    context '異常系' do
      context 'contentが空の場合' do
        let(:content) { '' }
        it 'データは無効である' do
          expect(comment.valid?).to be(false)
        end
      end

      context 'contentが255文字以上の場合' do
        let(:content) { 'a' * 256 }
        it 'データは無効である' do
          expect(comment.valid?).to be(false)
        end
      end
    end
  end
end
