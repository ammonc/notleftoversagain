class ShoppingListItem < ActiveRecord::Base
  validates_presence_of :shopping_list_id
end
