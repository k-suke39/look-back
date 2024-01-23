# frozen_string_literal: true

require 'rails_helper'

describe 'Scraps', type: :request do
  before do
    @user = create(:user)
    @scrap = create(:scrap)
  end
  describe 'GET /scraps' do
    context 'ログインしていない場合' do
      it 'HTTPステータス200を返す' do
        get '/scraps'
        expect(response).to have_http_status(200)
      end
    end

    context 'ログイン済みの場合' do
      it 'HTTPステータス200を返す' do
        sign_in @user
        get '/scraps'
        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'GET /scraps/id' do
    context 'ログインしていない場合' do
      it 'HTTPステータス200を返す' do
        get "/scraps/#{@scrap.id}"
        expect(response).to have_http_status(200)
      end
    end

    context 'ログイン済みの場合' do
      it 'HTTPステータス200を返す' do
        get "/scraps/#{@scrap.id}"
        expect(response).to have_http_status(200)
      end
    end
  end
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

  describe 'GET /scraps/id/edit' do
    context 'ログインしていない場合' do
      it 'HTTPステータス302を返す' do
        get "/scraps/#{@scrap.id}/edit"
        expect(response).to have_http_status(302)
      end
    end
    context 'ログイン済みの場合' do
      before { sign_in @user }
      it 'HTTPステータス200を返す' do
        get "/scraps/#{@scrap.id}/edit"
        expect(response).to have_http_status(200)
      end
    end
  end
end
