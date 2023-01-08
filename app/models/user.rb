class User < ApplicationRecord
  # Associations
  has_many :categories
  has_many :accounts
  has_many :transactions, through: :accounts
  # has_many :subcategories, through: :categories
  # Validations
  validates :first_name, :last_name, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
