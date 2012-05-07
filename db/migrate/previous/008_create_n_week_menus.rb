class CreateNWeekMenus < ActiveRecord::Migration
  def self.up
    create_table :n_week_menus do |t|
      # just an id that groups weekly menus through a foreign key, whose table defines everything
      #t.column "name", :string
      #t.column "start_date", :string
      #t.column "end_date", :string
    end
  end

  def self.down
    drop_table :n_week_menus
  end
end
