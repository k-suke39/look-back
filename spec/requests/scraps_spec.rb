# frozen_string_literal: true

require 'rails_helper'

describe 'Scraps', type: :request do
  before { @user = create(:user) }
  describe 'GET /scraps/new' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get '/scraps/new'
        expect(response).to have_http_status(302)
      end

      it 'ログインページにリダイレクトされる' do
        get '/scraps/new'
        expect(response).to redirect_to '/users/sign_in'
      end
    end

    context 'ログインしている場合' do
      before { sign_in @user }
      it 'HTTPステータス200を返す' do
        get '/scraps/new'
        expect(response).to have_http_status(200)
      end

      it 'ログインページにリダイレクトされない' do
        get '/scraps/new'
        expect(response).not_to redirect_to '/users/sign_in'
      end
    end
  end
end