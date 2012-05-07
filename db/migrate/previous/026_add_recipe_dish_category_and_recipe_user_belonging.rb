class AddRecipeDishCategoryAndRecipeUserBelonging < ActiveRecord::Migration
  def self.up
    create_table :dish_categories do |t|
      t.column :name, :string
    end
    DishCategory.reset_column_information
    DishCategory.new(:name => 'Main Dish').save!
    DishCategory.new(:name => 'Side Dish').save!
    DishCategory.new(:name => 'Vegetable').save!
    DishCategory.new(:name => 'Dessert').save!
    DishCategory.new(:name => 'Misc').save!
    
    add_column :recipes, :user_id, :integer 
    add_column :recipes, :dish_category_id, :integer 
    
    add_index :recipes, :dish_category_id
    add_index :recipes, :user_id
  end

  def self.down
    drop_table :dish_categories 
    remove_column :recipes, :user_id
    remove_column :recipes, :dish_category_id
  end
end
