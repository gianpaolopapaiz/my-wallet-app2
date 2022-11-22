class AddSubcategoryToCategory < ActiveRecord::Migration[7.0]
  def change
    add_reference :categories, :subcategory, foreign_key: true
  end
end
