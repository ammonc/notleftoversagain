class CreateRecipes < ActiveRecord::Migration
  def self.up
    create_table :recipes do |t|
      t.column :name, :string
      t.column :servings, :integer, {:limit => 2}            # not usually a float
      t.column :prep_time_hours, :integer, {:limit => 2}
      t.column :prep_time_minutes, :integer, {:limit => 2}
      t.column :cook_time_hours, :integer, {:limit => 2}
      t.column :cook_time_minutes, :integer, {:limit => 2}
      t.column :instructions, :text           # 
      t.column :feedback, :text               # what people thought of it when you made it
      t.column :rating, :integer, {:limit => 2}              # number of stars out of 5
      t.column :source, :string               # author/web site/cookbook
      t.column :added_by_user_id, :integer    # who entered it
      t.column :recipe_category_id, :integer  # which category this recipe belongs in 
    end
  end

  def self.down
    drop_table :recipes
  end
end
