require 'rails_helper'

RSpec.describe Transaction, type: :model do
  before :each do
    @user = create(:user)
    @account = create(:account, user: @user)
    @date = Date.current
  end

  context 'validates name' do
    it 'does not create a transaction without title' do
      transaction = Transaction.create(name: nil,
                                       description: 'Sample description',
                                       account: @account,
                                       date: @date,
                                       value: 10)

      expect(transaction.errors.messages[:name][0]).to eq("can't be blank")
    end

    it 'does not create a transaction with name with more than 30 characters' do
      name = ''
      31.times do
        name += 'a'
      end
      transaction = Transaction.create(name: name,
                                       description: 'Sample description',
                                       account: @account,
                                       date: @date,
                                       value: 10)

      expect(transaction.errors.messages[:name][0]).to eq("is too long (maximum is 30 characters)")
    end
  end

  it 'does not create a transaction without date' do
    transaction = Transaction.create(name: 'Sample Title',
                                     description: 'Sample description',
                                     account: @account,
                                     date: nil,
                                     value: 10)

    expect(transaction.errors.messages[:date][0]).to eq("can't be blank")
  end

  it 'does not create a transaction with value other than a number' do
    transaction = Transaction.create(name: 'Sample Title',
                                     description: 'Sample description',
                                     account: @account,
                                     date: @date,
                                     value: 'string')

    expect(transaction.errors.messages[:value][0]).to eq("is not a number")
  end

  it 'does not create a transaction with description with more than 50 characters' do
    description = ''
    51.times do
      description += 'a'
    end
    transaction = Transaction.create(name: 'Sample Title',
                                     description: description,
                                     account: @account,
                                     date: @date,
                                     value: 10)

    expect(transaction.errors.messages[:description][0]).to eq("is too long (maximum is 50 characters)")
  end

  it 'does not create a transaction without account' do
    transaction = Transaction.create(name: 'Sample Title',
                                     description: 'Sample description',
                                     account: nil,
                                     date: @date,
                                     value: 10)

    expect(transaction.errors.messages[:account][0]).to eq("must exist")
  end
end