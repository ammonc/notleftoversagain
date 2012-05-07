class AllowRecipeAndNWeekMenuSharing < ActiveRecord::Migration
  def self.up
    add_column :n_week_menus, :user_id, :integer
    
    create_table :share_specific_recipes_w_friend do |t|
      t.column :recipe_id, :integer    
      t.column :sharer_user_id, :integer
      t.column :sharee_user_id, :integer
    end
    create_table :share_all_recipes_w_friend do |t|
      t.column :sharer_user_id, :integer
      t.column :sharee_user_id, :integer
    end
    
    create_table :share_specific_n_week_menus_w_friend do |t|
      t.column :n_week_menu_id, :integer    
      t.column :sharer_user_id, :integer
      t.column :sharee_user_id, :integer
    end
    create_table :share_all_n_week_menus_w_friend do |t|
      t.column :sharer_user_id, :integer
      t.column :sharee_user_id, :integer
    end

    # indices...?
  end

  def self.down
    drop_table :share_specific_recipes_w_friend 
    drop_table :share_all_recipes_w_friend 
    drop_table :share_specific_n_week_menus_w_friend 
    drop_table :share_all_n_week_menus_w_friend 
    
    remove_column :n_week_menus, :user_id
  end
end
