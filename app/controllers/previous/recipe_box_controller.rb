class RecipeBoxController < ApplicationController
  # recipe methods
  def index
    #list
    #render :action => 'list'
    redirect_to :action => 'cockpit'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # I don't know what to do here...
  # verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  def cockpit
    list
  end

  def list
    @recipe_pages, @recipes = paginate(:recipes, :include => [:recipe_category, :dish_category], :per_page => 10)
  end

  def search_recipes_sandbox
    @recipe_categories = RecipeCategory.find(:all, :order => 'name')
    @dish_categories = DishCategory.find(:all, :order => 'name')
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @mode = 'new'
    @recipe = Recipe.new
    @recipe_categories = RecipeCategory.find(:all, :order => 'name')
    @dish_categories = DishCategory.find(:all)
  end
  
  
  def edit
    @mode = 'edit'
    @recipe = Recipe.find(params[:id])
    @recipe_categories = RecipeCategory.find(:all, :order => 'name')
    @dish_categories = DishCategory.find(:all)
  end

  
  def create
    @recipe = Recipe.new(params[:recipe])
    if @recipe.save
      flash[:notice] = 'Recipe was successfully created.'
      redirect_to :action => 'edit', :id => @recipe.id
    else
      render :action => 'new'
    end
  end


  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(params[:recipe])
      flash[:notice] = 'Recipe was successfully updated.'
      redirect_to :action => 'edit', :id => @recipe
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    Recipe.find(params[:id]).destroy
    # TODO Here we'd need to also delete the recipe from all meals that contain it...
    redirect_to :action => 'list'
  end


  # ingredient methods

  def add_ingredient
    recipe_id = params[:recipe_id].to_i
    @recipe = Recipe.find(recipe_id)
    @ingredient = @recipe.ingredients.build
    @units = Unit.find(:all, :order => 'name')
    @ingredient_categories = IngredientCategory.find(:all, :order => 'name')
    render_partial 'new_ingredient'
  end

  def create_ingredient
    logger.debug params[:ingredient].inspect
    ingredient = Ingredient.new(params[:ingredient])
    ingredient.save
    @recipe = Recipe.find(ingredient.recipe_id)
    render_partial 'ingredients_list'
  end
  
  def edit_ingredient
    logger.debug params[:ingredient].inspect
    ingredient_id = params[:ingredient][:id]
    @ingredient = Ingredient.find(ingredient_id)
    @recipe = @ingredient.recipe
    @units = Unit.find(:all, :order => 'abbrev')
    @ingredient_categories = IngredientCategory.find(:all, :order => 'name')
    render_partial 'edit_ingredient'
  end
  
  def update_ingredient
    logger.debug params[:ingredient].inspect
    ingredient = Ingredient.find(params[:ingredient][:id])
    ingredient.update_attributes(params[:ingredient])
    ingredient.save
    @recipe = Recipe.find(ingredient.recipe_id)
    render_partial 'ingredients_list'
  end
  
  def delete_ingredient
    logger.debug params[:ingredient][:id]
    ingredient = Ingredient.find(params[:ingredient][:id])
    @recipe = Recipe.find(ingredient.recipe_id)
    ingredient.destroy
    render_partial 'ingredients_list'
  end
  
  
  # ingredient_category methods
  
  def add_ingredient_category
    # should add functionality to make sure duplicates aren't added
    @new_ingredient_category = IngredientCategory.new(:name => params[:ingredient_category_name])
    @new_ingredient_category.save
    @ingredient_categories = IngredientCategory.find(:all, :order => 'name')
    render_partial 'ingredient_category_select'
  end
 
 
  # unit methods
  
  def add_unit
    logger.debug params.inspect
  
    # should add functionality to make sure duplicates aren't added
    @new_unit = Unit.new(:name => params[:unit_name], :abbrev => params[:unit_abbrev])
    @new_unit.save
    @units = Unit.find(:all, :order => 'abbrev')
    render_partial 'unit_select'
  end


  # auto_complete methods:

  # auto_complete Ingredient.name
  def auto_complete_for_ingredient_name
    value = params[:ingredient][:name]
    @ingredients = Ingredient.find(:all, 
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + value.downcase + '%' ], 
      :order => 'name ASC',
      :limit => 8)
    render :partial => 'ingredient_name_matches'
  end
  
 private
  def auto_complete_responder_for_contacts(value)
    @contacts = Contact.find(:all, 
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + value.downcase + '%' ], 
      :order => 'name ASC',
      :limit => 8)
    render :partial => 'contacts'
  end

end
