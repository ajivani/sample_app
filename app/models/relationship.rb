# == Schema Information
# Schema version: 20101005110648
#
# Table name: relationships
#
#  id          :integer         not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id #since this will be changed by users, we don't want maliciious users to choose who can follow them or force other users to follow the

  belongs_to :follower, :class_name=>"User" #relationship.follower
  belongs_to :followed, :class_name=>"User" #relationship.followed.user

  validates :follower_id, :presence=>true
  validates :followed_id, :presence=>true

end
