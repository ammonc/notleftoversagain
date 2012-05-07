class AddNWeekMenuColumns < ActiveRecord::Migration
  def self.up
    add_column :n_week_menus, "name", :string
    add_column :n_week_menus, "start_date", :string
    add_column :n_week_menus, "end_date", :string
  end

  def self.down
    remove_column :n_week_menus, "name"
    remove_column :n_week_menus, "start_date"
    remove_column :n_week_menus, "end_date"
  end
end
