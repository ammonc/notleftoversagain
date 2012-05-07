class AddIndicesForIngredientsRecipesAndShoppingLists < ActiveRecord::Migration
  def self.up
    add_index :ingredients, :recipe_id                # for quick relations through this table 
    add_index :ingredients, :ingredient_category_id   # for quick relations through this table
    add_index :ingredients, :name                     # for using SQL to GROUP BY name, unit_id so we can use SQL to combine some recipes that use the same unit and the same name for the same thing
    add_index :ingredients, :unit_id                  # for using SQL to GROUP BY name, unit_id

    add_index :recipes, :recipe_category_id           # for faster searches by recipe category (faster joins) 

    add_index :shopping_list_items, :ingredient_category_id   # for quick relations through this table
    add_index :shopping_list_items, :name             # for using SQL to GROUP BY name, unit_id so we can use SQL to combine the shopping_list_items (pretty much ingredients) that use the same unit and the same name for the same thing
    add_index :shopping_list_items, :unit_id          # for using SQL to GROUP BY name, unit_id

  end

  def self.down
    remove_index :ingredients, :recipe_id                
    remove_index :ingredients, :ingredient_category_id  
    remove_index :ingredients, :name                   
    remove_index :ingredients, :unit_id               

    remove_index :recipes, :recipe_category_id       

    remove_index :shopping_list_items, :ingredient_category_id   
    remove_index :shopping_list_items, :name           
    remove_index :shopping_list_items, :unit_id       
  end
end
