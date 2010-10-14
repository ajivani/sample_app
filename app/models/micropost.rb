# == Schema Information
# Schema version: 20101005110648
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

# == Schema Information
# Schema version: 20101001194035
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
class Micropost < ActiveRecord::Base
#we only want the content field editable by users, nothing more
  attr_accessible :content

  belongs_to :user
  
  validates :content, :presence=>true, :length => {:maximum => 140}
  validates :user_id, :presence=>true
  
  default_scope :order => 'microposts.created_at DESC'

  #scope takes a function and a block that calls another function
  #pretty cool
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private
    #return a sql condition for users followed by the given user.
    #include the users own id as well
    def self.followed_by(user)
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id", 
            {:user_id => user})
    end


end

#the where is the same as saying
#SELECT * FROM microposts
#WHERE user_id IN (SELECT followed_id FROM relationships
#                  WHERE follower_id = 1)
#      OR user_id = 1
#



  #had this in the public section, but it doesn't scale very well
  #so we need to add scopes. if we had 50000 followings then we'd be pulling out all 50,0000 instead with scopes you can chain methods and call User.admin.paginate(:page=>1) to only pull out like 30 at a time
  #def self.from_users_followed_by(user)
   # followed_ids = user.following.map(&:id).join(", ")
   # where("user_id IN (#{followed_ids}) OR user_id = ?", user)
  #end
  

