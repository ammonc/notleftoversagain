class CreateShoppingListItems < ActiveRecord::Migration
  def self.up
    create_table :shopping_list_items do |t|
      t.column :shopping_list_id, :integer    # which shopping list (which already specifies the user) this item belongs to
      t.column :name, :string     # how much you have on hand of what and in what unit 
      t.column :amount, :string  
      t.column :unit_id, :integer
    end
  end

  def self.down
    drop_table :shopping_list_items
  end
end
