class DbUpdate < ActiveRecord::Migration
  def self.up
    # take care of scheduling a meal at a specific time of day/meal of day, where the day is linked to a week which is linked to a single_meal_menu
    create_table :single_day_menus_single_meal_menus do |t|
      t.column :single_day_menu_id, :integer
      t.column :meal_of_day_number, :integer   
      t.column :single_meal_menu_id, :integer
      # no user_id because that is tracked on the two ends - recipes and n_week_menus;  you can choose to share your recipes or your n_week menus, both, or neither
    end
    add_index :single_day_menus_single_meal_menus, :single_day_menu_id
    add_index :single_day_menus_single_meal_menus, :single_meal_menu_id
    
    add_column :recipes, :shared, :boolean 
    add_index :recipes, :shared 
    
    add_column :n_week_menus, :shared, :boolean  # few n_week_menus so an index really isn't necessary
  end

  def self.down
    add_index :recipes, :shared 
    remove_column :recipes, :shared, :boolean 
    
    remove_column :n_week_menus, :shared
    
    remove_index :single_day_menus_single_meal_menus, :single_day_menu_id
    remove_index :single_day_menus_single_meal_menus, :single_meal_menu_id
    drop_table :single_day_menus_single_meal_menus
  end
end
