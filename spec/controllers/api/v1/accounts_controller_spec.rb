require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :request do
  before :each do
    @user = create(:user)
    @account = create(:account, user: @user)
    @account2 = create(:account,
                       name: "Account 2",
                       description: "Account 2 description",
                       user: @user)
    post '/users/sign_in', params: { user: { email: @user.email, password: @user.password } }
  end

  it "INDEX - gets accounts related to the user" do
    get '/api/v1/accounts'
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(parsed_body.count).to eq(2)
    expect(parsed_body.first['id']).to eq(@account.id)
    expect(parsed_body.last['id']).to eq(@account2.id)
  end

  it "SHOW - gets an account related to the user" do
    get "/api/v1/accounts/#{@account2.id}"
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(parsed_body['id']).to eq(@account2.id)
    expect(parsed_body['name']).to eq('Account 2')
  end

  it "CREATE - creates an account related to the user" do
    accounts_count = Account.all.size
    params = {
      account:
        {
          name: 'Account 3',
          description: 'Account 3 description',
          initial_amount: 15.5
        }
    }

    post "/api/v1/accounts", params: params
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(201)
    expect(Account.all.size).to eq(accounts_count + 1)
    expect(parsed_body['name']).to eq('Account 3')
    expect(parsed_body['description']).to eq('Account 3 description')
    expect(parsed_body['initial_amount']).to eq(15.5)
  end

  it "Updates - creates an account related to the user" do
    accounts_count = Account.all.size
    params = {
      account:
        {
          name: 'Account 3',
          description: 'Account 3 description',
          initial_amount: 15.5
        }
    }

    patch "/api/v1/accounts/#{@account2.id}", params: params
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(Account.all.size).to eq(accounts_count)
    expect(parsed_body['name']).to eq('Account 3')
    expect(@account2.reload.name).to eq('Account 3')
    expect(parsed_body['description']).to eq('Account 3 description')
    expect(@account2.description).to eq('Account 3 description')
    expect(parsed_body['initial_amount']).to eq(15.5)
    expect(@account2.initial_amount).to eq(15.5)
  end

  it "DESTROY - destroys an account related to the user" do
    accounts_count = Account.all.size
    delete "/api/v1/accounts/#{@account2.id}"
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(Account.all.size).to eq(accounts_count - 1)
    expect(parsed_body['message']).to eq('Account successfully destroyed')
  end

  context 'when does not work returns an error message' do
    it "CREATE - does not create an account related to the user" do
      accounts_count = Account.all.size
      params = {
        account:
          {
            name: 'Account 3',
            description: 'Account 3 description',
            initial_amount: 15.5
          }
      }

      allow_any_instance_of(Account).to receive(:save).and_return(false)
      post "/api/v1/accounts", params: params

      expect(response.status).to eq(422)
      expect(Account.all.size).to eq(accounts_count)
    end

    it "Updates - creates an account related to the user" do
      accounts_count = Account.all.size
      params = {
        account:
          {
            name: 'Account 3',
            description: 'Account 3 description',
            initial_amount: 15.5
          }
      }

      allow_any_instance_of(Account).to receive(:update).and_return(false)
      patch "/api/v1/accounts/#{@account2.id}", params: params

      expect(response.status).to eq(422)
      expect(Account.all.size).to eq(accounts_count)
      expect(@account2.reload.name).not_to eq('Account 3')
      expect(@account2.description).not_to eq('Account 3 description')
      expect(@account2.initial_amount).not_to eq(15.5)
    end

    it "DESTROY - destroys an account related to the user" do
      accounts_count = Account.all.size
      allow_any_instance_of(Account).to receive(:destroy).and_return(false)
      delete "/api/v1/accounts/#{@account2.id}"

      expect(response.status).to eq(422)
      expect(Account.all.size).to eq(accounts_count)
    end
  end

  context 'for another user accounts' do
    before :each do
      @user2 = create(:user, email: 'user2@email.com')
      @account3 = create(:account,
                         name: "Account 3",
                         description: "Account 3 description",
                         user: @user2)
      @account4 = create(:account,
                         name: "Account 4",
                         description: "Account 4 description",
                         user: @user2)
    end

    it "INDEX - gets only accounts related to the user" do
      get '/api/v1/accounts'
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(parsed_body.count).to eq(2)
      expect(parsed_body.first['id']).to eq(@account.id)
      expect(parsed_body.last['id']).to eq(@account2.id)
    end

    it "SHOW - does not show" do
      get "/api/v1/accounts/#{@account3.id}"
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(parsed_body['message']).to eq('You are not authorized')
    end

    it "UPDATE - does not update" do
      params = {
        account:
          {
            name: 'Account 5',
            description: 'Account 5 description',
            initial_amount: 15.5
          }
      }
      patch "/api/v1/accounts/#{@account3.id}", params: params
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(parsed_body['message']).to eq('You are not authorized')
    end

    it "DESTROY - does not destroy" do
      delete "/api/v1/accounts/#{@account3.id}"
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(parsed_body['message']).to eq('You are not authorized')
    end
  end
end