# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require_dependency "login_system"

class ApplicationController < ActionController::Base
  include LoginSystem
  model :user
  
  def do_recipe_search
    recipe_name_provided = provided(params[:recipe][:name])
    ingredient_provided = provided(params[:ingredient][:name])
    recipe_category_provided = provided(params[:recipe][:recipe_category_id])
    dish_category_provided = provided(params[:recipe][:dish_category_id])
    
    logger.debug params[:recipe].inspect
    logger.debug provided(params[:recipe][:time_limit_hours]) 
    logger.debug provided(params[:recipe][:time_limit_minutes])
    time_limit_provided = provided(params[:recipe][:time_limit_hours]) || provided(params[:recipe][:time_limit_minutes])
    #|| needed not or
    
    #logger.debug time_limit_provided.inspect
    
    rating_provided = provided(params[:recipe][:rating])
    source_provided = provided(params[:recipe][:source])

    params[:recipe][:time_limit_hours] = "0" if !provided(params[:recipe][:time_limit_hours])  # default to 0 if not provided (nil or blank)
    params[:recipe][:time_limit_minutes] = "0" if !provided(params[:recipe][:time_limit_minutes])  # default to 0 if not provided (nil or blank)
    
    tables = ['recipes']
    conditions = []
    if recipe_name_provided or ingredient_provided or (recipe_category_provided  and params[:recipe][:recipe_category_id] != '0') or (dish_category_provided  and params[:recipe][:dish_category_id] != '0') or time_limit_provided or rating_provided or source_provided
      if recipe_name_provided
        recipe_name_condition = "(LOWER(recipes.name) LIKE '%#{params[:recipe][:name].downcase}%')" 
        conditions << recipe_name_condition
      end
      if ingredient_provided
        ingredient_condition = "((LOWER(ingredients.name) LIKE '%#{params[:ingredient][:name].downcase}%') AND (ingredients.recipe_id = recipes.id))" # include join here
        conditions << ingredient_condition
	tables << 'ingredients'
      end
      if recipe_category_provided and params[:recipe][:recipe_category_id] != '0'  # 0 means search all categories
        recipe_category_condition = "(recipes.recipe_category_id = #{params[:recipe][:recipe_category_id]})" 
        conditions << recipe_category_condition
      end
      if dish_category_provided and params[:recipe][:recipe_category_id] != '0'  # 0 means search all categories
        dish_category_condition = "(recipes.dish_category_id = #{params[:recipe][:dish_category_id]})" 
        conditions << dish_category_condition
      end
      if time_limit_provided
        time_limit_condition = "(((recipes.prep_time_hours + recipes.cook_time_hours) * 60 + (recipes.prep_time_minutes + recipes.cook_time_minutes)) <= (#{params[:recipe][:time_limit_hours]} * 60 + #{params[:recipe][:time_limit_minutes]}))" 
        conditions << time_limit_condition
      end
      if rating_provided
        rating_condition = "(recipes.rating >= #{params[:recipe][:rating]})" 
        conditions << rating_condition
      end
      if source_provided
        recipe_source_condition = "(recipes.source LIKE '%#{params[:recipe][:source]}%')" 
        conditions << recipe_source_condition
      end

      sql_str = "SELECT recipes.* from #{tables.join(', ')}\n WHERE #{conditions.join(' AND ')}"
      logger.debug sql_str
      @recipes = Recipe.find_by_sql(sql_str)
      return render_text("No matching results found given search criteria.") if @recipes.empty?
      render_partial 'recipe_search_results'
    else
      render_text "No search criteria provided."
    end
  end
  
 private 

  def provided(val)
    return false if val.nil? or val.strip.empty?  # If nil or empty (excluding whitespace on either end), then consider it empty
    return true
  end
end
