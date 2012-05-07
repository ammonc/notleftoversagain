require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base

  has_many :n_week_menus
  has_many :recipes
  
  has_many :shopping_lists
  has_many :on_hand_ingredients
  
  # TODO dish_categories doesn't have a user_id field yet
  # has_many :dish_categories  # each user would like to have his/her own dish_categories, ingredient_categories, etc.  BUT when they decide to copy it to their own recipe box (must be a deep copy not just a link in case the other user then decides to delete their recipes!) their dish_categories and ingredient_categories must be copied too
  
  # TODO ingredient_categories doesn't have a user_id field yet
  # has_many :ingredient_categories   # the default ingredient_categories and dish_categories should be created for new users...

  def self.authenticate(login, pass)
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end  

  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end
    
 protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
    
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password))
  end

  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation
  validates_uniqueness_of :login, :on => :create
  validates_confirmation_of :password, :on => :create     
end
