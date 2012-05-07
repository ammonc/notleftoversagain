class CreateOnHandIngredients < ActiveRecord::Migration
  def self.up
    create_table :on_hand_ingredients do |t|
      t.column :user_id, :integer # who has these ingredients on hand
      t.column :name, :string     # how much you have on hand of what and in what unit (must be in an available unit so that we can add and convert)
      t.column :amount, :string  
      t.column :unit_id, :integer
    end
  end

  def self.down
    drop_table :on_hand_ingredients
  end
end
