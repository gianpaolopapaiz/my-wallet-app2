require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :request do
  before :each do
    @user = create(:user)
    @account = create(:account, user: @user)
  end

  it 'returns a json response when tries to fetch info without being logged in' do
    get '/api/v1/accounts'
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(401)
    expect(parsed_body['message']).to eq('You need to sign in or sign up')
  end
end
