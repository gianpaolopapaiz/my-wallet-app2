class Category < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions
  has_many :subcategories, dependent: :destroy

  # Validations
  validates :name, length: { maximum: 20 }, presence: true
  validates :description, length: { maximum: 50 }
end
