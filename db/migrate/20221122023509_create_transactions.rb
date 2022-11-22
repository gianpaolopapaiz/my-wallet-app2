class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :name
      t.text :description
      t.float :value
      t.references :category, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :subcategory, foreign_key: true
      t.string :check_number
      t.date :date

      t.timestamps
    end
  end
end
