class AddIndicesForSpeedyMenuQueries < ActiveRecord::Migration
  def self.up
    add_index :single_meal_menus, :single_day_menu_id
    add_index :single_day_menus, :weekly_menu_id
    add_index :weekly_menus, :n_week_menu_id
  end

  def self.down
    remove_index :single_meal_menus, :single_day_menu_id
    remove_index :single_day_menus, :weekly_menu_id
    remove_index :weekly_menus, :n_week_menu_id
  end
end
