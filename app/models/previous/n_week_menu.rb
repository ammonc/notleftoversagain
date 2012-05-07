class NWeekMenu < ActiveRecord::Base
  has_many :weekly_menus
  belongs_to :user
 
  def self.delete_incl_associations(n_week_menu_id)
    # work backwards - start with sdm_smms, then sdms, then wms, then finally nwm
    NWeekMenu.transaction do  # it either all gets deleted or none of it does
      sdm_ids = get_all_associated_single_day_menu_ids(n_week_menu_id)
      sdm_ids_comma_separated = sdm_ids.join(", ")
      SingleDayMenusSingleMealMenu.delete_all "single_day_menu_id IN (#{sdm_ids_comma_separated})"

      SingleDayMenu.delete_all "id IN (#{sdm_ids_comma_separated})"
      
      wm_ids = get_all_associated_weekly_menu_ids(n_week_menu_id)
      wm_ids_comma_separated = wm_ids.join(", ")
      WeeklyMenu.delete_all "id IN (#{wm_ids_comma_separated})"

      NWeekMenu.delete_all "id = #{n_week_menu_id}"
    end  
  end
 
  def self.clone_incl_associations(n_week_menu_id, for_user_id)
    n_week_menu_clone = nil
    NWeekMenu.transaction do  # it either all gets copied or none of it does
      current_n_week_menu = NWeekMenu.find(n_week_menu_id)
      n_week_menu_clone = NWeekMenu.new(current_n_week_menu.attributes)
      n_week_menu_clone.user_id = for_user_id 
      n_week_menu_clone.save!

      # copy over weekly_menus
      for current_weekly_menu in current_n_week_menu.weekly_menus do
	weekly_menu_clone = WeeklyMenu.new(current_weekly_menu.attributes)
	weekly_menu_clone.n_week_menu_id = n_week_menu_clone.id
	weekly_menu_clone.save!

	# copy over single_day_menus
        for current_single_day_menu in current_weekly_menu.single_day_menus do
	  current_single_day_menu_clone = SingleDayMenu.new(current_single_day_menu.attributes)
	  current_single_day_menu_clone.weekly_menu_id = weekly_menu_clone.id
	  current_single_day_menu_clone.save!

	  # copy over single_day_menus_single_meal_menus
	  for current_sdm_smm in current_single_day_menu.single_meal_menus do
	    current_sdm_smm_clone = SingleDayMenusSingleMealMenu.new(current_sdm_smm.attributes)
	    current_sdm_smm_clone.single_day_menu_id = current_single_day_menu_clone.id
	    current_sdm_smm_clone.save!
	  end  
	end  
      end	
    end  
    

    # TODO:  DESIGN DECISION:  what if the recipes that it depends on or the ingredients of a recipe or the meal menu changes?!!!  -  best plan is to make multiple copies...
    # TODO:  deep copy meal menus, recipes, ingredients...

   
    return n_week_menu_clone
  end


  # first step to getting all the ingredients needed for an n_week_menu_id is finding all the single_meal_menus associated with the n_week_menu - just need the id here though
  def self.get_all_associated_weekly_menu_ids(n_week_menu_id)
    get_all_associated_weekly_menus_helper("id", n_week_menu_id).collect { |smm| smm.id }
  end
  
  def self.get_all_associated_weekly_menus(n_week_menu_id)
    get_all_associated_weekly_menus_helper("*", n_week_menu_id)
  end

  def self.get_all_associated_weekly_menus_helper(select, n_week_menu_id)
    find_by_sql("SELECT weekly_menus.#{select} FROM weekly_menus\nWHERE (weekly_menus.n_week_menu_id = #{n_week_menu_id})")
    #find(n_week_menu_id).weekly_menus  # this one doesn't allow the select as I have it set up
  end


  
  # single_day_menus
  def self.get_all_associated_single_day_menu_ids(n_week_menu_id)
    get_all_associated_single_day_menus_helper("id", n_week_menu_id).collect { |smm| smm.id }
  end
  
  def self.get_all_associated_single_day_menus(n_week_menu_id)
    get_all_associated_single_day_menus_helper("*", n_week_menu_id)
  end
    
  def self.get_all_associated_single_day_menus_helper(select, n_week_menu_id)
    find_by_sql("SELECT single_day_menus.#{select} FROM single_day_menus, weekly_menus\nWHERE (single_day_menus.weekly_menu_id = weekly_menus.id) AND (weekly_menus.n_week_menu_id = #{n_week_menu_id})")
  end  


  # single_meal_menus
  def self.get_all_associated_single_meal_menu_ids(n_week_menu_id)
    get_all_associated_single_meal_menus_helper("id", n_week_menu_id).collect { |smm| smm.id }
  end
  
  def self.get_all_associated_single_meal_menus(n_week_menu_id)
    get_all_associated_single_meal_menus_helper("*", n_week_menu_id)
  end
    
  def self.get_all_associated_single_meal_menus_helper(select, n_week_menu_id)
    find_by_sql("SELECT single_meal_menus.#{select} FROM single_meal_menus, single_day_menus_single_meal_menus, single_day_menus, weekly_menus\nWHERE (single_meal_menus.id = single_day_menus_single_meal_menus.single_meal_menu_id)\n\tAND (single_day_menus_single_meal_menus.single_day_menu_id = single_day_menus.id) \n\tAND (single_day_menus.weekly_menu_id = weekly_menus.id) AND (weekly_menus.n_week_menu_id = #{n_week_menu_id})")
  end  

  
  
  # recipes
  # TODO look in drag_n_drop_n_week_menu_planner method for the SQL and refactor here (for the extra columns!!!)
  def self.get_all_associated_recipe_ids(n_week_menu_id)
    get_all_associated_recipes_helper("id", n_week_menu_id).collect { |smm| smm.id }
  end
  
  def self.get_all_associated_recipes(n_week_menu_id)
    get_all_associated_recipes_helper("*", n_week_menu_id)
  end
    
  def self.get_all_associated_recipes_helper(select, n_week_menu_id)
    find_by_sql("SELECT recipes.#{select} FROM recipes, recipes_single_meal_menus, single_meal_menus, single_day_menus_single_meal_menus, single_day_menus, weekly_menus\nWHERE (recipes.id = recipes_single_meal_menus.recipe_id) AND (recipes_single_meal_menus.single_meal_menu_id = single_meal_menus.id) AND (single_meal_menus.id = single_day_menus_single_meal_menus.single_meal_menu_id)\n\tAND (single_day_menus_single_meal_menus.single_day_menu_id = single_day_menus.id) \n\tAND (single_day_menus.weekly_menu_id = weekly_menus.id) AND (weekly_menus.n_week_menu_id = #{n_week_menu_id})")
  end  



  # ingredients
  # TODO look in do_shopping_list method for the SQL and refactor here (in case I want extra columns!!!)
  def self.get_all_associated_ingredient_ids(n_week_menu_id)
    get_all_associated_ingredients_helper("id", n_week_menu_id).collect { |smm| smm.id }
  end
  
  def self.get_all_associated_ingredients(n_week_menu_id)
    get_all_associated_ingredients_helper("*", n_week_menu_id)
  end
    
  def self.get_all_associated_ingredients_helper(select, n_week_menu_id)
    find_by_sql("SELECT ingredients.#{select} FROM ingredients, recipes, recipes_single_meal_menus, single_meal_menus, single_day_menus_single_meal_menus, single_day_menus, weekly_menus\nWHERE (ingredients.recipe_id = recipes.id) AND (recipes.id = recipes_single_meal_menus.recipe_id) AND (recipes_single_meal_menus.single_meal_menu_id = single_meal_menus.id) AND (single_meal_menus.id = single_day_menus_single_meal_menus.single_meal_menu_id)\n\tAND (single_day_menus_single_meal_menus.single_day_menu_id = single_day_menus.id) \n\tAND (single_day_menus.weekly_menu_id = weekly_menus.id) AND (weekly_menus.n_week_menu_id = #{n_week_menu_id})")
  end  
  
end
