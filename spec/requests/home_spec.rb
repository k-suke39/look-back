# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET /' do
    it 'HTTPステータス 200を返すこと' do
      get '/'
      expect(response).to have_http_status(200)
    end
  end
end
