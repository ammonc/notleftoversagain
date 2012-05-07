class MenuPlannerController < ApplicationController
  MEALS_PER_DAY = 3 

  def index
    redirect_to :action => 'show_existing_n_week_menus'
  end
 
  
  def drag_n_drop_n_week_menu_planner
    n_week_menu_id = params[:n_week_menu_id]
    @n_week_menu = NWeekMenu.find(n_week_menu_id)
    
    @single_meal_menus = SingleMealMenu.find(:all, :limit => 10)

    single_day_menus = SingleDayMenu.find_by_sql("SELECT wm.week_number, sdm.day_of_week, sdm.id AS single_day_menu_id \nFROM single_day_menus sdm, weekly_menus wm \nWHERE ( (sdm.weekly_menu_id = wm.id) AND (wm.n_week_menu_id = #{n_week_menu_id}) ) \nORDER BY wm.week_number, sdm.day_of_week")
    recipes = Recipe.find_by_sql("SELECT sdmsmm.id AS sdm_smm_id, sdmsmm.single_day_menu_id, sdmsmm.meal_of_day_number, sdmsmm.single_meal_menu_id, r.name \nFROM recipes r, recipes_single_meal_menus rsmm, single_meal_menus smm, single_day_menus_single_meal_menus sdmsmm, single_day_menus sdm, weekly_menus wm \nWHERE ( (r.id = rsmm.recipe_id) AND (rsmm.single_meal_menu_id = smm.id) AND (sdmsmm.single_meal_menu_id = smm.id) AND (sdmsmm.single_day_menu_id = sdm.id) AND (sdm.weekly_menu_id = wm.id) AND (wm.n_week_menu_id = #{n_week_menu_id}) ) \nORDER BY wm.week_number, sdm.day_of_week, sdmsmm.meal_of_day_number")

    @day_of_week_names = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] 
    
    # The meal times and names should eventually come from the database and be defined by each individual user.  The week day names could come from the Date class...
    #@meal_times = ["7:00 am", "10:00 am", "1:00 pm", "4:00 pm", "7:00 pm", "10:00 pm"] 
    #@meal_names = ["Breakfast", "Second Breakfast", "Lunch", "Dinner", "Supper", "Evening Snack"] 
    #@meal_of_day_numbers = [1, 2, 3, 4, 5, 6]
    @meal_times = ["7:00 am", "12:00 pm", "6:00 pm"] 
    @meal_names = ["Breakfast", "Lunch", "Dinner"] 
    @meal_of_day_numbers = [1, 2, 3]
    
    @week_numbers = single_day_menus.collect { |sdm| sdm.week_number.to_i }.uniq.sort
    @day_of_week_numbers = [0, 1, 2, 3, 4, 5, 6] 
   
    logger.debug single_day_menus.size
   
    i = 0
    @weeks = {}
    for week_number in @week_numbers do
      week = []
      for day_of_week in @day_of_week_numbers do
        day = single_day_menus[i] 
	# CHANGED to SDMs only - sdm_id and meal_of_day_number used in place of smm_id
=begin	  
	sdms = single_day_menus.select { |sdm| (sdm.week_number.to_i == week_number) && (sdm.day_of_week.to_i == day_of_week) && (sdm.meal_of_day_number.to_i == meal_of_day_number) }  # select returns [] if no matches   NOTE:  CATCH: These extra fields are all returned in string form!!!
	logger.debug sdms.size, sdms.inspect
	sdm = sdms.first  
	raise 'NilSDMException' if sdm.nil?
=end	  
	i += 1
	week << day
      end
      @weeks[week_number] = week
    end
    
    @recipes_by_day = {}
    single_day_menu_ids = recipes.collect { |r| r.single_day_menu_id.to_i }.uniq.sort  # only the days that have recipes will show up, others will be nil when accessed in the hash
    for single_day_menu_id in single_day_menu_ids do
      @recipes_by_day[single_day_menu_id] = {}
      for meal_of_day_number in @meal_of_day_numbers do 
	@recipes_by_day[single_day_menu_id][meal_of_day_number] = recipes.select { |r| (r.single_day_menu_id.to_i == single_day_menu_id) && (r.meal_of_day_number.to_i == meal_of_day_number) }  # filter out the recipes that go on the right day at the right meal time/slot
=begin      
      #.collect { |r| r.name }.join(", ")  
      # the select is a filter and the collect just grabs the name part; the join turns it into a comma separated list
      # That would have worked well, but we need the smm_id
=end      
      end
    end
    
    #render_text @weeks[1][1][1].inspect
    #render_text @recipes_by_day[single_day_menu_ids.first][1].inspect
  end

  def schedule_meal_week_day_and_time
    logger.debug params.inspect

    #weekly_menu_id = params[:weekly_menu_id].to_i
    #day_of_week = params[:day_of_week].to_i       # these two together can identify the single_day_menu_id, but it is easier to just use the single_day_menu_id on its own
    # Find single_day_menu_id with given weekly_menu_id, day_of_week
    # @single_day_menu = SingleDayMenu.find(:all, :conditions => "(weekly_menu_id = #{weekly_menu_id}) AND (day_of_week = #{day_of_week})")
    
    single_day_menu_id = params[:single_day_menu_id].to_i
    @meal_of_day_number = params[:meal_of_day_number].to_i 
    single_meal_menu_id = params[:single_meal_menu_html_id].split("_").last.to_i 

    # actually do the scheduling
    # Case 1. find out if there is already something scheduled there, in which case we'll do an UPDATE
    # Case 2. if nothing there yet, do an INSERT 
    
    @sdm_smm = SingleDayMenusSingleMealMenu.find_first( "(single_day_menu_id = #{single_day_menu_id}) AND (meal_of_day_number = #{@meal_of_day_number})" )

    logger.debug @sdm_smm.inspect

    # need the id for the column just updated/inserted for use in the delete, so used ActiveRecord instead of straignt INSERT/DELETE!
    if @sdm_smm  # if the row already exists is what I mean here  (if the find_first fails then @sdm_smm is nil, otherwise it has a value that will be interpreted as true)
      #SingleDayMenusSingleMealMenu.connection.execute "UPDATE single_day_menus_single_meal_menus SET single_meal_menu_id = #{single_meal_menu_id}"
      @sdm_smm.single_meal_menu_id = single_meal_menu_id
      @sdm_smm.save!
    else
      #SingleDayMenusSingleMealMenu.connection.execute "INSERT INTO single_day_menus_single_meal_menus(single_day_menu_id, meal_of_day_number, single_meal_menu_id) VALUES(#{single_day_menu_id}, #{meal_of_day_number}, #{single_meal_menu_id})"
      @sdm_smm = SingleDayMenusSingleMealMenu.new
      @sdm_smm.single_meal_menu_id = single_meal_menu_id
      @sdm_smm.single_day_menu_id = single_day_menu_id
      @sdm_smm.meal_of_day_number = @meal_of_day_number
      @sdm_smm.save!
    end
    
    # for the partial to be reusable
    @sdm_id = @sdm_smm.single_day_menu_id
    @smm_id = @sdm_smm.single_meal_menu_id
    @sdm_smm_id = @sdm_smm.id
    
    #render_partial 'schedule_meal_week_day_and_time'
    render_partial 'meal_menu'
  end
  
  def unschedule_meal
    logger.debug params.inspect
    single_day_menus_single_meal_menus_id = params[:id].to_i 
    
    # actually do the unscheduling
    SingleDayMenusSingleMealMenu.delete single_day_menus_single_meal_menus_id
    
    render_text "Drop meal here!<br />&nbsp;"
  end



  # n_week_menu editor
  def show_existing_n_week_menus
    @n_week_menus = NWeekMenu.find_all  # how to display the one that they're looking for - display calendar w/ meals?
  end

  def delete_n_week_menu
    n_week_menu_id = params[:id]
    NWeekMenu.destroy n_week_menu_id
    
    redirect_to :action => 'show_existing_n_week_menus'
  end

=begin  # INCOMPLETE - but for updating the start/end date, name, other metadata items...
  # have to provide the n_week_menu_id in params[:id]
  def update_n_week_menu 
    n_week_menu_id = params[:id].to_i 
    @n_week_menu = NWeekMenu.find(n_week_menu_id) 
  end
=end

=begin  # deprecated in favor of drag n drop
  # have to provide the n_week_menu_id in params[:id]
  def show_n_week_menu 
    n_week_menu_id = params[:id].to_i 
    @n_week_menu = NWeekMenu.find(n_week_menu_id) 
  end
=end
  
  def start_new_n_week_menu
    num_weeks = params[:num_weeks].to_i
    n_week_menu = NWeekMenu.new( { :name => params[:name], :start_date => params[:start_date], :end_date => params[:end_date]  } )
    n_week_menu.save!
    NWeekMenu.transaction do
      create_new_weekly_menus(n_week_menu.id, num_weeks)
    end  
    #redirect_to :action => 'show_n_week_menu', :id => n_week_menu.id
    redirect_to :action => 'drag_n_drop_n_week_menu_planner', :n_week_menu_id => n_week_menu.id
  end

  # recipe - meal form:  meal_definition is the main form
  def meal_definition
    @recipe_categories = RecipeCategory.find(:all, :order => 'name')
    @dish_categories = DishCategory.find(:all)
    
    @recipe = Recipe.new  # start with a blank recipe for the form
    
    #@single_meal_menus = SingleMealMenu.find(:all, :include => :recipes)  # this clobbers the recipe_id with the habtm join table id!  We either need to write our own custom query or deal with the slowness of a query on the recipes for each SMM
    @single_meal_menus = SingleMealMenu.find(:all)
  end

  def list_all_meals
    @single_meal_menus = SingleMealMenu.find(:all)
    render_partial 'list_all_meals'
  end  

  def delete_recipe_from_meal
    recipe_id = params[:recipe_id].split('_').last.to_i
    @single_meal_menu_id = params[:single_meal_menu_id].to_i
    
    #logger.debug
    #logger.debug params.inspect
    @rsmm = RecipesSingleMealMenus.find(:all, :conditions => "(recipe_id = #{recipe_id}) AND (single_meal_menu_id = #{@single_meal_menu_id})", :limit => 1).first
    #logger.debug @rsmm.inspect
    #logger.debug @rsmm.id
    #logger.debug
    #logger.debug
    RecipesSingleMealMenus.delete(@rsmm.id)

    @smm = SingleMealMenu.find(@single_meal_menu_id)
    
    show_single_meal_helper
  end
  
  def add_recipe_to_meal
    recipe_id = params[:recipe_id].split('_').last.to_i
    @single_meal_menu_id = params[:single_meal_menu_id].to_i
    result_str = "Recipe ##{recipe_id} added to SingleMealMenu ##{@single_meal_menu_id}"
    puts result_str 

    if @single_meal_menu_id < 1  # This takes care of new == 0, and it might take care of nil.to_i as well
      @smm = SingleMealMenu.new
      @smm.save!
      @single_meal_menu_id = @smm.id
    else
      @smm = SingleMealMenu.find(@single_meal_menu_id)
    end
    
    recipe = Recipe.find(recipe_id)
   
    #RecipesSingleMealMenus.connection.execute "INSERT INTO recipes_single_meal_menus(recipe_id, single_meal_menu_id) VALUES(#{recipe.id}, #{@smm.id})"
    rsmm = RecipesSingleMealMenus.new( :recipe_id => recipe.id, :single_meal_menu_id => @smm.id )
    rsmm.save!
   
    show_single_meal_helper
  end
 
  def delete_single_meal
    @single_meal_menu_id = params[:single_meal_menu_id].to_i 
    SingleMealMenu.delete(@single_meal_menu_id)
    RecipesSingleMealMenus.delete_all("single_meal_menu_id = #{@single_meal_menu_id}")
    
    @single_meal_menus = SingleMealMenu.find(:all)
    render_text "Deleted meal menu #{@single_meal_menu_id}"
  end
  
  def show_single_meal
    @single_meal_menu_id = params[:single_meal_menu_id].to_i
    if @single_meal_menu_id < 1  # This takes care of new == 0, and it might take care of nil.to_i as well
      @smm = SingleMealMenu.new
      #@smm.save!  # Don't need to create new bogus single meal menus.  Don't actually create it until a recipe is added to it.
      @smm_just_created = true
    else
      @smm = SingleMealMenu.find(@single_meal_menu_id)
      @smm_just_created = false
    end
    show_single_meal_helper
  end
 
 private

  def show_single_meal_helper
    #smm_recipes = @smm.recipes  # This clobbers the recipe id with the habtm table id
    smm_recipes = Recipe.find_by_sql("SELECT r.id, r.name, r.dish_category_id FROM recipes r, recipes_single_meal_menus rsmms WHERE r.id = rsmms.recipe_id AND rsmms.single_meal_menu_id = #{@single_meal_menu_id}")
   
    #puts smm_recipes.inspect
   
    @smm_recipes_by_dish_category = Hash.new()
    for recipe in smm_recipes do
      raise 'RecipeDoesntHaveDishCategoryException' if recipe.dish_category_id.nil? or recipe.dish_category_id == 0
      @smm_recipes_by_dish_category[recipe.dish_category_id] = [] if @smm_recipes_by_dish_category[recipe.dish_category_id].nil?
      @smm_recipes_by_dish_category[recipe.dish_category_id] << recipe  # if recipe.dish_category_id == current_dish_category.id
    end
   
    #puts @smm_recipes_by_dish_category.inspect
   
    @dish_categories = DishCategory.find(:all)
    render_partial 'show_single_meal'
  end

  
  def add_week_to_n_week_menu(n_week_menu_id)
    create_new_weekly_menus(n_week_menu_id, 1)
  end

  def create_new_weekly_menus(n_week_menu_id, number_weekly_menus_to_create)
    for week_number in 1..number_weekly_menus_to_create do
      create_new_weekly_menu(n_week_menu_id, week_number)
    end
  end
  
  
  def create_new_weekly_menu(n_week_menu_id, week_number)
    weekly_menu = WeeklyMenu.new( { :n_week_menu_id => n_week_menu_id, :week_number => week_number } )
    weekly_menu.save
    for day_of_week_number in 0..6 do  # use day of week numbered values consistent with Date objects - 0 is Sunday; 6 is Saturday
      create_new_single_day_menu(weekly_menu.id, day_of_week_number)
    end
  end

  def create_new_single_day_menu(weekly_menu_id, day_of_week)
    single_day_menu = SingleDayMenu.new( { :weekly_menu_id => weekly_menu_id, :day_of_week => day_of_week } )
    single_day_menu.save!

=begin # Instead of making lots of blank ones, create them on demand...   
    max_num_recipes = Recipe.count
    for i in 1..MEALS_PER_DAY do
      #single_meal_menu = SingleMealMenu.new   # This doesn't work because id is the only column and the SQL automatically generated doesn't work
      #single_meal_menu.save!
      max_smm_id = nil
      # transaction started earlier  
      #SingleMealMenu.transaction do  # these 2 lines must be inside a transaction since we don't want two requests to execute the MAX statement simultaneously and then raise and Exception for a duplicate primary key
        max_smm_id = SingleMealMenu.find_by_sql("SELECT MAX(id) AS max_id FROM single_meal_menus").first.max_id.to_i
	SingleMealMenu.connection.execute("INSERT INTO single_meal_menus(id) VALUES(#{max_smm_id + 1})")
      #end
      single_meal_menu = SingleMealMenu.find(max_smm_id + 1)

      sdm_smm = SingleDayMenusSingleMealMenu.new(:single_day_menu_id => single_day_menu.id, :single_meal_menu_id => single_meal_menu.id, :meal_of_day_number => i)
      sdm_smm.save!
      
      num_recipes_for_meal = rand(max_num_recipes) + 1  # at least 1; at most max_num_recipes
      for j in 1..num_recipes_for_meal do
        rsmm = RecipesSingleMealMenu.new(:single_meal_menu_id => single_meal_menu.id, :recipe_id => j, :servings => 6)
	rsmm.save!
      end
    end
=end

  end
  
end
