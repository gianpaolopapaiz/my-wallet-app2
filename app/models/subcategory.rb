class Subcategory < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :transactions
  has_one :user, through: :category
  # Validations
  validates :name, length: { maximum: 20 }, presence: true
  validates :description, length: { maximum: 50 }
end
