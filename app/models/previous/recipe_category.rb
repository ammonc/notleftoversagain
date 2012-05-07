class RecipeCategory < ActiveRecord::Base
  has_many :recipes   # many recipes belong to each category
end
