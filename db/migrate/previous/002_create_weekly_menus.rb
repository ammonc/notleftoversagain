class CreateWeeklyMenus < ActiveRecord::Migration
  def self.up
    create_table :weekly_menus do |t|
      t.column :n_week_menu_id, :integer      # which NWeekMenu this WeeklyMenu belongs to 
      t.column :week_number, :integer         # sequences week order in an NWeekMenu, (1..N)
    end
  end

  def self.down
    drop_table :weekly_menus
  end
end
