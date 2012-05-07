class CreateRecipesSingleMealMenus < ActiveRecord::Migration
  def self.up
    create_table :recipes_single_meal_menus do |t|
      t.column :recipe_id, :integer
      t.column :single_meal_menu_id, :integer
      t.column :servings, :float
    end
    add_index :recipes_single_meal_menus, :recipe_id
    add_index :recipes_single_meal_menus, :single_meal_menu_id
  end

  def self.down
    remove_index :recipes_single_meal_menus, :recipe_id
    remove_index :recipes_single_meal_menus, :single_meal_menu_id
    drop_table :recipes_single_meal_menus
  end
end
