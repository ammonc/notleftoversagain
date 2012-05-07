class PopulateIngredientCategories < ActiveRecord::Migration
  def self.up
    IngredientCategory.reset_column_information
    IngredientCategory.new({:name => "Bread"}).save
    IngredientCategory.new({:name => "Vegetable"}).save
    IngredientCategory.new({:name => "Fruit"}).save
    IngredientCategory.new({:name => "Condiment"}).save
    IngredientCategory.new({:name => "Canned"}).save
    IngredientCategory.new({:name => "Dessert"}).save
    IngredientCategory.new({:name => "Frozen"}).save
    IngredientCategory.new({:name => "Diet"}).save
    IngredientCategory.new({:name => "Dairy"}).save
    IngredientCategory.new({:name => "Meat"}).save
    IngredientCategory.new({:name => "Poultry"}).save
  end

  def self.down
    IngredientCategory.delete_all
  end
end
