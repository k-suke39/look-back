# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homes', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'ヘッダーの検証' do
    context 'ログインしていない場合' do
      before { visit '/' }

      it 'ユーザ登録のリンクを表示する' do
        expect(page).to have_link('ユーザー登録', href: '/users/sign_up')
      end
      it 'ログインのリンクを表示する' do
        expect(page).to have_link('ログイン', href: '/users/sign_in')
      end

      it 'ログアウトのリンクを表示しない' do
        expect(page).not_to have_content('ログアウト')
      end
    end
    context 'ログインしている場合' do
      before do
        user = create(:user)
        sign_in user
        visit '/'
      end
      it 'ログアウトのリンクを表示する' do
        expect(page).to have_content('ログアウト')
      end
      it 'ユーザ登録のリンクを表示しない' do
        expect(page).not_to have_link('ユーザー登録', href: '/users/sign_up')
      end
      it 'ログインのリンクを表示しない' do
        expect(page).not_to have_link('ログイン', href: '/users/sign_in')
      end
      it 'ログアウトのリンクが正常に動作する' do
        click_button 'ログアウト'
        expect(page).to have_link('ユーザー登録', href: '/users/sign_up')
        expect(page).to have_link('ログイン', href: '/users/sign_in')
        expect(page).not_to have_content('ログアウト')
      end
    end
  end
end