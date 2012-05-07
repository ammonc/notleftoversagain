class Recipe < ActiveRecord::Base
  belongs_to :recipe_category
  belongs_to :dish_category
  belongs_to :user
  has_many :ingredients
  has_and_belongs_to_many :single_meal_menus

  validates_presence_of :name
  validates_presence_of :servings
  validates_numericality_of :servings
  # validates_range_of :servings  # 1-99?
  validates_presence_of :prep_time_minutes
  validates_presence_of :cook_time_minutes
  validates_numericality_of :prep_time_minutes, :only_integer => true
  validates_numericality_of :cook_time_minutes, :only_integer => true
  # hours can be left blank - but I need to make sure this turns into saving 0!!

  validates_presence_of :user_id  # ? how to make sure this is nonzero?
  validates_presence_of :dish_category_id  # ? how to make sure this is nonzero?
  validates_presence_of :recipe_category_id  # ? how to make sure this is nonzero?
  validates_numericality_of :user_id, :only_integer => true  
  validates_numericality_of :dish_category_id, :only_integer => true  
  validates_numericality_of :recipe_category_id, :only_integer => true  
end
