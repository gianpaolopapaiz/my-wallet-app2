class AddUserToSubcategories < ActiveRecord::Migration[7.0]
  def change
    add_reference :subcategories, :user, null: false, foreign_key: true
  end
end
