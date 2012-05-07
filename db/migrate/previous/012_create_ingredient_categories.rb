class CreateIngredientCategories < ActiveRecord::Migration
  def self.up
    create_table :ingredient_categories do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :ingredient_categories
  end
end
