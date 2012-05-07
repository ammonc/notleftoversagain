class PopulateRecipeCategories < ActiveRecord::Migration
  def self.up
    RecipeCategory.reset_column_information
    RecipeCategory.new({:name => "Main Dish"}).save
    RecipeCategory.new({:name => "Salad"}).save
    RecipeCategory.new({:name => "Dessert"}).save
    RecipeCategory.new({:name => "Side"}).save
    RecipeCategory.new({:name => "Family Tradition"}).save
  end

  def self.down
    RecipeCategory.delete_all
  end
end
