class CreateRecipeCategories < ActiveRecord::Migration
  def self.up
    create_table :recipe_categories do |t|
      t.column :name, :string
    end
  end

  def self.down
    drop_table :recipe_categories
  end
end
