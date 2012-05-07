class CreateSingleDayMenus < ActiveRecord::Migration
  def self.up
    create_table :single_day_menus do |t|
      # provides an id that ScheduledSingleMealMenus can link to
      t.column :weekly_menu_id, :integer      # the id of this table will be different across the rest of the data here, so this number uniquely groups
      t.column :day_of_week, :integer         # 0 is Sunday, 6 is Saturday
    end
  end

  def self.down
    drop_table :single_day_menus
  end
end
