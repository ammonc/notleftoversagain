class AddIndicesForIngredientsAndCategories < ActiveRecord::Migration
  def self.up
    add_column :shopping_list_items, :ingredient_category_id, :integer 
  end

  def self.down
    remove_column :shopping_list_items, :ingredient_category_id
  end
end
