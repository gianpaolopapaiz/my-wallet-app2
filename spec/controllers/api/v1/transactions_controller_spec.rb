require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :request do
  before :each do
    @user = create(:user)
    @account = create(:account, user: @user)
    @account2 = create(:account, name: 'Account 2', user: @user)
    @category = create(:category, user: @user)
    post '/users/sign_in', params: { user: { email: @user.email, password: @user.password } }
  end

  it "INDEX - gets transactions related to the account" do
    t1 = create(:transaction, account: @account)
    t2 = create(:transaction, account: @account)
    create(:transaction, account: @account2)

    get "/api/v1/accounts/#{@account.id}/transactions"
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(parsed_body.count).to eq(2)
    expect(parsed_body.first['id']).to eq(t1.id)
    expect(parsed_body.last['id']).to eq(t2.id)
  end

  it "CREATE - creates a transaction related to an account" do
    transaction_count = Transaction.all.size
    current_date = Date.current
    params = {
      account_id: @account.id,
      transaction:
        {
          name: 'Transaction 1',
          description: 'Transaction 1 description',
          value: 10.5,
          date: current_date
        }
    }

    post "/api/v1/accounts/#{@account.id}/transactions", params: params
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(201)
    expect(Transaction.all.size).to eq(transaction_count + 1)
    expect(parsed_body['name']).to eq('Transaction 1')
    expect(parsed_body['description']).to eq('Transaction 1 description')
    expect(parsed_body['value']).to eq(10.5)
    expect(parsed_body['date']).to eq(current_date.strftime('%Y-%m-%d'))
    expect(parsed_body['account_id']).to eq(@account.id)
  end
end