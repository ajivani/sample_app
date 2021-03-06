# == Schema Information
# Schema version: 20101001194035
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password #we need to be accept password and password confirmation as part of the signup process, we'll add that to our accessible attributes
  #this is very important, sets what the user can be edited through the web -- that's why we didn't put admin here, or else a user could just use the console to toggle the admin attribute
  attr_accessible :name, :email, :password, :password_confirmation #equivalent to saying attr_accessible(:name, :email)
  has_many :microposts, :dependent=> :destroy #user.microposts  #has_many :microposts, :foreign_key=>'user_id', :dependent=> :destroy
  has_many :relationships, :foreign_key=> 'follower_id', :dependent=>:destroy #user.follower
  has_many :following, :through=>:relationships, :source=> :followed #user.following
  has_many :reverse_relationships,  :foreign_key=>'followed_id',
                                    :class_name=>'Relationship',
                                    :dependent=>:destroy
  has_many :followers, :through=>:reverse_relationships, :source=>:follower #might actually be more for the  #user.followers
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence=> true,
                    :length=>{ :maximum => 50 }
  validates :email, :presence=> true,
                    :format => {:with=> email_regex},
                    :uniqueness => { :case_sensitive => false}
  #automatically create the virtual attribute 'password_confirmation'
  validates :password,  :presence =>  true,
                        :confirmation => true,
                        :length => {:within => 6..40 }
  before_save :encrypt_password
  #scope example
  scope :admin, where(:admin=>true) #would give the
  

  def following?(some_followed_user)
    self.relationships.find_by_followed_id(some_followed_user) #self is user
  end
  def unfollow!(user_to_unfollow)
    rel = relationships.find_by_followed_id(user_to_unfollow)
    rel.destroy
  end
  def follow!(user_to_follow)
    relationships.create!(:followed_id => user_to_follow.id) #build would return a relationships object create saves it int he database in one step
  end
  def feed 
    Micropost.from_users_followed_by(self)  #Micropost.where("user_id = ?", id) #self.id where self is the user
  end
  #Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password) #in a method def, self is just the object ie probably ameen or some other user 
  end
  #returns user if email and password match
  def self.authenticate(email_given, submitted_password)
    user = User.find_by_email(email_given)
    return nil if user.nil? #no email
    return user if user.has_password?(submitted_password) #correct
    nil #wrong password
  end
  def self.authenticate_with_salt(user_id, cookie_salt)
    user = User.find_by_id(user_id)
    (user && user.salt == cookie_salt)? user : nil
  end
  private
  def encrypt_password
    self.salt = make_salt if new_record? #this way the salt is created once and only when the user is first created
    self.encrypted_password = encrypt(password)
  end
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
end
