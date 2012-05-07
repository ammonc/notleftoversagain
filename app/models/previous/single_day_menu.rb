class SingleDayMenu < ActiveRecord::Base
  #belongs_to :weekly_menu
  has_and_belongs_to_many :single_meal_menus

  validates_presence_of :weekly_menu_id
  validates_presence_of :day_of_week
  validates_numericality_of :weekly_menu_id, :only_integer => true
  validates_numericality_of :day_of_week, :only_integer => true
  
end
