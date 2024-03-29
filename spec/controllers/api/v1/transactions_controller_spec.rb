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

  it "SHOW - gets a category related to the user" do
    @transaction = create(:transaction, account: @account)

    get "/api/v1/accounts/#{@account.id}/transactions/#{@transaction.id}"
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(parsed_body['id']).to eq(@transaction.id)
    expect(parsed_body['name']).to eq('Transaction 1')
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

  it "UPDATE - updates an account related to the user" do
    @transaction = create(:transaction, account: @account)
    transactions_count = Transaction.all.size
    params = {
      transaction:
        {
          name: 'Transaction 2',
          description: 'Transaction 2 description',
          value: 15.5
        }
    }

    patch "/api/v1/accounts/#{@account.id}/transactions/#{@transaction.id}", params: params
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(Transaction.all.size).to eq(transactions_count)
    expect(parsed_body['name']).to eq('Transaction 2')
    expect(@transaction.reload.name).to eq('Transaction 2')
    expect(parsed_body['description']).to eq('Transaction 2 description')
    expect(@transaction.description).to eq('Transaction 2 description')
    expect(parsed_body['value']).to eq(15.5)
    expect(@transaction.value).to eq(15.5)
  end

  it "DESTROY - destroys a transaction" do
    @transaction = create(:transaction, account: @account)
    transactions_count = Transaction.all.size

    delete "/api/v1/accounts/#{@account.id}/transactions/#{@transaction.id}"
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(Transaction.all.size).to eq(transactions_count - 1)
    expect(parsed_body['message']).to eq('Transaction successfully destroyed')
  end

  context 'when does not work returns an error message' do
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

      allow_any_instance_of(Transaction).to receive(:save).and_return(false)
      post "/api/v1/accounts/#{@account.id}/transactions", params: params

      expect(response.status).to eq(422)
      expect(Transaction.all.size).to eq(transaction_count)
    end

    it "UPDATE - updates an account related to the user" do
      @transaction = create(:transaction, account: @account)
      transactions_count = Transaction.all.size
      params = {
        transaction:
          {
            name: 'Transaction 2',
            description: 'Transaction 2 description',
            value: 15.5
          }
      }

      allow_any_instance_of(Transaction).to receive(:update).and_return(false)
      patch "/api/v1/accounts/#{@account.id}/transactions/#{@transaction.id}", params: params

      expect(response.status).to eq(422)
      expect(Transaction.all.size).to eq(transactions_count)
      expect(@transaction.reload.name).to eq('Transaction 1')
      expect(@transaction.description).to eq('Transaction 1 description')
      expect(@transaction.value).to eq(10.5)
    end

    it "DESTROY - destroys a transaction" do
      @transaction = create(:transaction, account: @account)
      transactions_count = Transaction.all.size

      allow_any_instance_of(Transaction).to receive(:destroy).and_return(false)
      delete "/api/v1/accounts/#{@account.id}/transactions/#{@transaction.id}"

      expect(response.status).to eq(422)
      expect(Transaction.all.size).to eq(transactions_count)
    end
  end
end