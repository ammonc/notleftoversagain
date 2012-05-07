class Ingredient < ActiveRecord::Base
  belongs_to :ingredient_category
  belongs_to :unit
  belongs_to :recipe

  def self.find_all_by_smm_id_arr(single_meal_menu_ids)
    find_by_sql("SELECT i.ingredient_category_id, i.name AS ingredient_name, i.unit_id, ic.name AS ingredient_category_name, i.amount, u.name AS unit_name, u.abbrev AS unit_abbrev, i.id, i.recipe_id, r.name AS recipe_name, r.servings AS recipe_servings, rsmm.servings as meal_servings \nFROM ingredients i, recipes r, ingredient_categories ic, units u, recipes_single_meal_menus rsmm \nWHERE rsmm.single_meal_menu_id IN (#{single_meal_menu_ids.join(', ')}) \n\tAND i.unit_id = u.id AND i.recipe_id = r.id AND r.id = rsmm.recipe_id AND i.ingredient_category_id = ic.id\nGROUP BY i.ingredient_category_id, i.name, i.unit_id")
  end  

  validates_presence_of :unit_id
  validates_presence_of :ingredient_category_id
  validates_presence_of :recipe_id
  validates_numericality_of :unit_id, :only_integer => true
  validates_numericality_of :ingredient_category_id, :only_integer => true
  validates_numericality_of :recipe_id, :only_integer => true
end
