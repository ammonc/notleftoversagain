class CreateUnitConversions < ActiveRecord::Migration
  def self.up
    # smaller_unit_amount of smaller_unit = 1 larger_unit
    create_table :unit_conversions do |t|
      t.column :larger_unit_id, :integer
      t.column :smaller_unit_id, :integer
      t.column :smaller_unit_amount, :integer
    end
  end

  def self.down
    drop_table :unit_conversions
  end
end
