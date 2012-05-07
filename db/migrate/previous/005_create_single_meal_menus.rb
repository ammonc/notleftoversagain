class CreateSingleMealMenus < ActiveRecord::Migration
  def self.up
    create_table :single_meal_menus do |t|
    end
  end

  def self.down
    drop_table :single_meal_menus
  end
end
