class SingleMealMenu < ActiveRecord::Base
  has_and_belongs_to_many :recipes
  
  has_and_belongs_to_many :single_day_menus  # when the meals are scheduled
end
