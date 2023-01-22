class Transaction < ApplicationRecord
  # Associations
  belongs_to :category, optional: true
  belongs_to :subcategory, optional: true
  belongs_to :account
  has_one :user, through: :account
  # Validations
  validates :date, presence: true
  validates :name, length: { maximum: 30 }, presence: true
  validates :description, length: { maximum: 50 }
  validates :value, numericality: true
  # Scopes
  scope :filter_by_income, -> { where('value >= 0') }
  scope :filter_by_expense, -> { where('value < 0') }
  scope :filter_by_account, ->(account_id) { where('account_id = :account_id', account_id:) }
  scope :filter_by_category, ->(category_id) { where('category_id = :category_id', category_id:) }
  scope :filter_by_date, lambda { |start_date, end_date|
    where('date >= :start_date AND date <= :end_date',
          start_date:, end_date:)
  }

  def account_balance
    balance = account.initial_amount
    account.
      transactions.
      where('date <= :date', date:).
      order(date: :asc, id: :asc).
      each do |transaction|
      balance += transaction.value
      break if transaction == self
    end
    balance
  end
end
