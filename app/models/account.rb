class Account < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions, dependent: :destroy
  # Validations
  validates :name, length: { maximum: 20 }, presence: true, uniqueness: { scope: :user_id }
  validates :description, length: { maximum: 50 }
  validates :initial_amount, numericality: true

  def balance
    initial_amount + transactions.sum(:value)
  end

  def balance_by_date(date)
    initial_amount + transactions.where('date <= :date', date:).sum(:value)
  end

  def self.collection_balance
    sum = 0.00
    all.each { |account| sum += (account.balance || 0.00) }
    sum
  end
end
