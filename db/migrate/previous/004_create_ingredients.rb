class CreateIngredients < ActiveRecord::Migration
  def self.up
    create_table :ingredients do |t|
      t.column :amount, :string       # should be easily converted to a float by eval-ing it, but that could be a security risk; I just want to allow fractions since that is how many recipes are written
      t.column :name, :string       # name of ingredient 
      t.column :unit_id, :integer     # so that units are consistent and abbreviations and full names are not duplicated (so that reductions/translations to different units just work)
      t.column :ingredient_category_id, :integer  # for grouping for easier shopping
      t.column :recipe_id, :integer   # which recipe this ingredient belongs to/in
    end
  end

  def self.down
    drop_table :ingredients
  end
end
