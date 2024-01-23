# frozen_string_literal: true

require 'rails_helper'

describe 'Scrap', type: :system do
  before do
    driven_by :rack_test
    @user = create(:user)
  end

  let(:title) { 'テストタイトル' }
  let(:content) { 'テスト本文' }

  describe 'スクラップ投稿フォームの検証' do
    subject do
      fill_in 'scrap_title', with: title
      fill_in 'scrap_content', with: content
      click_button 'ログを記録'
    end
    context 'ログインしていない場合' do
      before { visit 'scraps/new' }
      it 'ログインページにリダイレクトされる' do
        expect(current_path).to eq('/users/sign_in')
        expect(page).to have_content('ログインしてください。')
      end
    end
    context 'ログイン済みの場合' do
      before do
        sign_in @user
        visit 'scraps/new'
      end
      it 'ログインページにリダイレクトされない' do
        expect(current_path).not_to eq('users/sign_in')
      end
      context '正常系' do
        it 'Scrapを作成できる' do
          expect { subject }.to change { Scrap.count }.by(1)
          expect(current_path).to eq('/')
          expect(page).to have_content('記録しました')
        end
      end
      context '異常系' do
        context 'titleが空の場合' do
          let(:title) { '' }
          it 'Scrapを作成できない' do
            expect { subject }.to change { Scrap.count }.by(0)
            expect(page).to have_content('記録に失敗しました')
          end

          it 'フォームに入力していた内容は保持される' do
            subject
            expect(page).to have_field('scrap_content', with: content)
          end
        end
      end
    end
  end
end