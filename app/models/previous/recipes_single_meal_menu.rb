class RecipesSingleMealMenu < ActiveRecord::Base
  # specifically, it groups recipes together into a cohesive unit to be served together as a meal, as well as specifying how many servings are needed from the recipe so the ingredients needed can be scaled accordingly
  
  # this model exists to replace the connection.execute "INSERT INTO" type statements, no more;  BUT ironically I haven't added the method yet because any Model.connection.execute works just fine
end
