class CreateUnits < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.column :name, :string
      t.column :abbrev, :string
    end
  end

  def self.down
    drop_table :units
  end
end
