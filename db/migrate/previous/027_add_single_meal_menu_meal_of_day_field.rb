class AddSingleMealMenuMealOfDayField < ActiveRecord::Migration
  def self.up
    add_column :single_meal_menus, :meal_of_day_number, :integer
  end

  def  self.down
    remove_column :single_meal_menus, :meal_of_day_number
  end
end
