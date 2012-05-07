class WeeklyMenu < ActiveRecord::Base
  belongs_to :n_week_menu
  has_many :single_day_menus

  validates_presence_of :n_week_menu_id

  # wait on delete, etc until it is needed - 
  #   on delete here I think the week_numbers would all need to be shifted down.  This can be done in 1 SQL update statement, though.
  #   also, a lot of the necessary code can be copied from the NWeekMenu methods
end
