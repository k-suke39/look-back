# frozen_string_literal: true

require 'rails_helper'

describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:nickname) { 'テスト太郎' }
  let(:email) { 'test@example.com' }
  let(:password) { '11111111' }
  let(:password_confirmation) { '11111111' }

  describe 'ユーザ登録機能の検証' do
    before { visit '/users/sign_up' }

    subject do
      fill_in 'user_nickname', with: nickname
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password_confirmation
      click_button 'ユーザー登録'
    end
    context '正常系' do
      it 'Userを作成できる' do
        expect { subject }.to change(User, :count).by(1)
        expect(current_path).to eq('/')
        expect(page).to have_content('ユーザー登録に成功しました。')
      end
    end
    context '異常系' do
      context 'nicknameが空の場合' do
        let(:nickname) { '' }
        it 'Userが作成されず、エラーメッセージが表示される' do
          expect { subject }.to change(User, :count).by(0)
          expect(page).to have_content('ニックネーム が入力されていません。')
        end
      end
      context 'nicknameが21文字以上の場合' do
        let(:nickname) { 'あ' * 21 }
        it 'Userが作成されず、エラーメッセージが表示される' do
          expect { subject }.to change(User, :count).by(0)
          expect(page).to have_content('ニックネーム は20文字以下に設定して下さい。')
        end
      end
      context 'emailが空の場合' do
        let(:email) { '' }
        it 'Userが作成されず、エラーメッセージが表示される' do
          expect { subject }.to change(User, :count).by(0)
          expect(page).to have_content('メールアドレス が入力されていません。')
        end
      end
      context 'passwordが空の場合' do
        let(:password) { '' }
        it 'Userが作成されず、エラーメッセージが表示される' do
          expect { subject }.to change(User, :count).by(0)
          expect(page).to have_content('パスワード が入力されていません。')
        end
      end
      context 'passwordが6文字未満の場合' do
        let(:password) { '11111' }
        it 'Userが作成されず、エラーメッセージが表示される' do
          expect { subject }.to change(User, :count).by(0)
          expect(page).to have_content('パスワード は6文字以上に設定して下さい。')
        end
      end
      context 'passwordが128文字を超える場合' do
        let(:password) { 'a' * 129 }
        it 'Userが作成されず、エラーメッセージが表示される' do
          expect { subject }.to change(User, :count).by(0)
          expect(page).to have_content('パスワード は128文字以下に設定して下さい。')
        end
      end
      context 'passwordとpassword_confirmaitonが一致しない時' do
        let(:password_confirmation) {  "#{password}11111" }
        it 'Userが作成されず、エラーメッセージが表示される' do
          expect { subject }.to change(User, :count).by(0)
          expect(page).to have_content('確認用パスワード が一致していません。')
        end
      end
    end
  end

  describe 'ユーザログイン機能の検証' do
    before do
      create(:user, nickname:, email:, password:, password_confirmation: password)
      visit '/users/sign_in'
      fill_in 'user_email', with: email
      fill_in 'user_password', with: '11111111'
      click_button 'ログイン'
    end
    context '正常系' do
      it 'ログインが成功し、トップページにリダイレクトする' do
        expect(current_path).to eq('/')
      end

      it 'ログイン成功時にフラッシュメッセージが表示される' do
        expect(page).to have_content('ログインしました。')
      end
    end
    context '異常系' do
      context 'passwordがNGの場合' do
        let(:password) { 'NGpassword' }
        it 'ログインに失敗し、トップページに遷移しない' do
          expect(current_path).to eq('/users/sign_in')
        end

        it 'ログイン失敗時にフラッシュメッセージを表示させる' do
          expect(page).to have_content('メールアドレスまたはパスワードが違います。')
        end
      end
    end
  end
end
