class AddSingleMealMenuSingleDayMenuLink < ActiveRecord::Migration
  def self.up
    add_column :single_meal_menus, 'single_day_menu_id', :integer
  end

  def self.down
    remove_column :single_meal_menus, 'single_day_menu_id'
  end
end
