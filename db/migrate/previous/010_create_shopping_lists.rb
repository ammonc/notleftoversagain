class CreateShoppingLists < ActiveRecord::Migration
  def self.up
    create_table :shopping_lists do |t|    # will have to be careful here to 
      t.column :user_id, :string           # which user this shopping list belongs to
      t.column :created, :datetime         # when this shopping list was created
      t.column :last_modified, :datetime   # when this shopping list was last_modified
    end
  end

  def self.down
    drop_table :shopping_lists
  end
end
