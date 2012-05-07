class PopulateUnitTable < ActiveRecord::Migration
  def self.up
    Unit.reset_column_information
    Unit.new({:name => "tablespoon", :abbrev => "tbsp" }).save   
    Unit.new({:name => "teaspoon", :abbrev => "tsp" }).save  
    Unit.new({:name => "ounce (fluid volume)", :abbrev => "fl. oz" }).save  
    Unit.new({:name => "ounce (weight)", :abbrev => "oz" }).save  
    Unit.new({:name => "pound", :abbrev => "lb" }).save  
    Unit.new({:name => "cup", :abbrev => "cup" }).save  
    Unit.new({:name => "quart", :abbrev => "qt" }).save  
    Unit.new({:name => "gallon", :abbrev => "gal" }).save  
  end

  def self.down
    Unit.delete_all
  end
end
