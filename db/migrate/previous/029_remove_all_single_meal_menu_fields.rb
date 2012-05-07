class RemoveAllSingleMealMenuFields < ActiveRecord::Migration
  def self.up
    remove_index :single_meal_menus, :single_day_menu_id    # have to remove indices on a column before you remove the column otherwise removing the column triggers removing the index, but the column no longer exists so it fails.
    remove_column :single_meal_menus, :single_day_menu_id
    remove_column :single_meal_menus, :meal_of_day_number
  end

  def self.down
    add_column :single_meal_menus, :single_day_menu_id, :integer
    add_column :single_meal_menus, :meal_of_day_number, :integer
  end
end
