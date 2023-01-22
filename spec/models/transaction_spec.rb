require 'rails_helper'

RSpec.describe Transaction, type: :model do
  before :each do
    @user = create(:user)
    @account = create(:account, user: @user)
    @date = Date.current
  end

  describe 'validations' do
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

  describe 'scopes' do
    before :each do
    end

    it 'filters by income' do
      t1 = create(:transaction, account: @account, value: 10)
      create(:transaction, account: @account, value: -10)
      transactions_filter = Transaction.all.filter_by_income

      expect(transactions_filter.count).to eq(1)
      expect(transactions_filter.first).to eq(t1)
    end
    it 'filters by expense' do
      create(:transaction, account: @account, value: 10)
      t2 = create(:transaction, account: @account, value: -10)
      transactions_filter = Transaction.all.filter_by_expense

      expect(transactions_filter.count).to eq(1)
      expect(transactions_filter.first).to eq(t2)
    end

    it 'filters by account' do
      account2 = create(:account, name: 'Account 2', user: @user)
      t1 = create(:transaction, account: @account)
      create(:transaction, account: account2)
      transactions_filter = Transaction.all.filter_by_account(@account.id)

      expect(transactions_filter.count).to eq(1)
      expect(transactions_filter.first).to eq(t1)
    end

    it 'filters by category' do
      category1 = create(:category, user: @user)
      category2 = create(:category, user: @user)
      t1 = create(:transaction, account: @account, category: category1)
      create(:transaction, account: @account, category: category2)
      transactions_filter = Transaction.all.filter_by_category(category1.id)

      expect(transactions_filter.count).to eq(1)
      expect(transactions_filter.first).to eq(t1)
    end

    it 'filters by date' do
      date1 = Date.current + 1.day
      date2 = Date.current - 1.day
      from_date = Date.current
      to_date = Date.current + 2.days
      t1 = create(:transaction, account: @account, date: date1)
      create(:transaction, account: @account, date: date2)
      transactions_filter = Transaction.all.filter_by_date(from_date, to_date)

      expect(transactions_filter.count).to eq(1)
      expect(transactions_filter.first).to eq(t1)
    end
  end

  describe 'instance methods' do
    it 'returns the account balance for a specific transaction' do
      t1 = create(:transaction, account: @account, value: 10, date: Date.current - 1.days)
      t2 = create(:transaction, account: @account, value: 10, date: Date.current + 1.days)
      t3 = create(:transaction, account: @account, value: 10, date: Date.current)
      t4 = create(:transaction, account: @account, value: 10, date: Date.current)

      expect(t1.account_balance).to eq(10)
      expect(t2.account_balance).to eq(40)
      expect(t3.account_balance).to eq(20)
      expect(t4.account_balance).to eq(30)
    end
  end
end
