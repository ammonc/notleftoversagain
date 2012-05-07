class ShoppingListController < ApplicationController

  def index
    # TODO:  show all shopping lists here instead?
    
    redirect_to :action => 'do_shopping_list', :n_week_menu_id => 1  # this will need to be changed for it to work on a per-user basis
  end

  def do_shopping_list
    logger.debug "Start of action: unschedule_meal_day_and_week"
    logger.debug params.inspect

    # food needed for recipes for N weeks - food on hand = food you need to buy (shopping list)
    
    n_week_menu_id = params[:n_week_menu_id].to_i
    @n_week_menu = NWeekMenu.find(n_week_menu_id)
    logger.debug @n_week_menu.inspect
    
    # These won't change even if recipes change.  They will change if they delete a week from the menu though.  But we haven't implemented that functionality yet...  The idea is to save the single_meal_menu_ids in the session (and then on a delete or add of a week to the menu, the query could be rerun or better yet the session variable could be set to nil (hash key removed) and then here we would just check the session cache)  BUT we'll mess with the session later in development
    
    @single_meal_menu_ids = NWeekMenu.get_all_associated_single_meal_menu_ids(n_week_menu_id)
    puts @single_meal_menu_ids.inspect unless RAILS_ENV == "production"
    
    @ingredients_needed_for_n_week_menu_before_merging = Ingredient.find_all_by_smm_id_arr(@single_meal_menu_ids)
    @ingredients_needed_for_n_week_menu = @ingredients_needed_for_n_week_menu_before_merging
    
    # group ingredients by category
    @ingredients_needed_for_n_week_menu_by_category = {}
    @ingredient_category_names = @ingredients_needed_for_n_week_menu.collect { |i| i.ingredient_category_name }.uniq
    for ingredient_category_name in @ingredient_category_names do
      @ingredients_needed_for_n_week_menu_by_category[ingredient_category_name] = @ingredients_needed_for_n_week_menu.select { |i| i.ingredient_category_name == ingredient_category_name } 
    end

    logger.debug @ingredients_needed_for_n_week_menu_by_category.inspect

    @units = Unit.find(:all, :order => 'abbrev')

    # TODO:  do unit conversions and mergings (using ruby-units!!!)
    # TODO:  need to do unit tests for conversions and mergings first

    # unit conversions edit/add/delete form - DONE!!! - great example for recipe instructions, etc..., but going to use ruby-units instead anyway

    # TODO:  since it is possible to make the same recipe multiple times in the N week menu, we could first get all the single_meal_menus (recipe*servings) transitively associated with the n_week_menu, thus grouping recipes that are associated with multiple single_meal_menus together and just adding the number of servings, then proceeding...  This is a smart optimization, but not worth the effort til performance is suffering

    # for now, just assume nothing is on hand
    @ingredients_on_hand = []
    # They just put in the amounts of what they have and possibly enter the amount in a different unit

    # TODO:  add some edit_distance functionality to ingredient names for inexact matching...
  end

  
end
