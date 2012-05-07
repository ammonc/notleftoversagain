class PopulateUnitConversions < ActiveRecord::Migration
  def self.up
    UnitConversion.reset_column_information
    UnitConversion.new({:larger_unit_id => Unit.find_by_abbrev("tbsp").id, :smaller_unit_id => Unit.find_by_abbrev("tsp").id, :smaller_unit_amount => 3 }).save  # 3 teaspoons in a tablespoon
    UnitConversion.new({:larger_unit_id => Unit.find_by_abbrev("cup").id, :smaller_unit_id => Unit.find_by_abbrev("fl. oz").id, :smaller_unit_amount => 8 }).save  # 8 fl. oz in a cup
    UnitConversion.new({:larger_unit_id => Unit.find_by_abbrev("lb").id, :smaller_unit_id => Unit.find_by_abbrev("oz").id, :smaller_unit_amount => 16 }).save  # 8 fl. oz in a cup
    UnitConversion.new({:larger_unit_id => Unit.find_by_abbrev("qt").id, :smaller_unit_id => Unit.find_by_abbrev("cup").id, :smaller_unit_amount => 4 }).save  # 4 cups. in a qt.
    UnitConversion.new({:larger_unit_id => Unit.find_by_abbrev("gal").id, :smaller_unit_id => Unit.find_by_abbrev("qt").id, :smaller_unit_amount => 4 }).save  # 4 qts. in a gal.
  end

  def self.down
    UnitConversion.delete_all
  end
end
