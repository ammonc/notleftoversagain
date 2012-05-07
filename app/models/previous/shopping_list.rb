class ShoppingList < ActiveRecord::Base
  has_many :shopping_list_items
end
