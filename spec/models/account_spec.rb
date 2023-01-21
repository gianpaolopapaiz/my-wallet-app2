require 'rails_helper'

RSpec.describe Account, type: :model do
  before :each do
    @user = create(:user)
    @account = create(:account, user: @user)
  end

  context 'validates name' do
    it 'does not create an account without name' do
      account = Account.create(user: @user,
                               name: nil,
                               description: 'Account 2 description',
                               initial_amount: 15.5)

      expect(account.errors.messages[:name][0]).to eq("can't be blank")
    end

    it 'does not create an account with the same name for the same user' do
      account = Account.create(user: @user,
                               name: 'Account 1',
                               description: 'Account 1 description',
                               initial_amount: 15.5)

      expect(account.errors.messages[:name][0]).to eq("has already been taken")
    end

    it 'creates an account with the same name for different users' do
      accounts_count = Account.all.size
      user2 = create(:user, email: 'user2@email.com')
      Account.create(user: user2,
                     name: 'Account 1',
                     description: 'Account 1 description',
                     initial_amount: 15.5)

      expect(Account.all.size).to eq(accounts_count + 1)
      expect(Account.last.name).to eq('Account 1')
    end

    it 'does not create and account with name with more than 20 characters' do
      name = ''
      21.times do
        name += 'a'
      end
      account = Account.create(user: @user,
                               name: name,
                               description: 'Account 2 description',
                               initial_amount: 15.5)

      expect(account.errors.messages[:name][0]).to eq("is too long (maximum is 20 characters)")
    end
  end

  it 'does not create an account with description with more than 50 characters' do
    description = ''
    51.times do
      description += 'a'
    end
    account = Account.create(user: @user,
                             name: 'Account 1',
                             description: description,
                             initial_amount: 15.5)

    expect(account.errors.messages[:description][0]).to eq("is too long (maximum is 50 characters)")
  end

  it 'does not create an account with initial_amount other than a number' do
    account = Account.create(user: @user,
                             name: 'Account 1',
                             description: 'Account 1 description',
                             initial_amount: 'string')

    expect(account.errors.messages[:initial_amount][0]).to eq("is not a number")
  end
end