require 'spec_helper'

describe Micropost do
  before(:each) do
    @user = Factory(:user)
    @attr= {:content=> "value for content"}
  end
  it  "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
  end
  describe 'user association' do
    before(:each) do
      @micropost = @user.microposts.create(@attr) 
    end
    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end#user association
  describe "validations" do
    it'should requrie a user id' do
      Micropost.new(@attr).should_not be_valid
    end
    it 'should require non blank content' do
      @user.microposts.build(:content=> "  ").should_not be_valid
    end
    it "should reject long content" do
      @user.microposts.build(:content=> "a"*141).should_not be_valid
    end
  end #validations

  describe "from_users_followed_by" do
    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email=> Factory.next(:email))

      @user_post = @user.microposts.create!(:content=>"foo")
      @other_post = @other_user.microposts.create!(:content=>"bar")
      @third_post = @third_user.microposts.create!(:content=>"baz")

      @user.follow!(@other_user)
    end
    it "should have a from_users_followed_by class method" do
      Micropost.should respond_to(:from_users_followed_by)
    end
    it "should include the followed users microposts" do
      Micropost.from_users_followed_by(@user).include?(@other_post).should be_true
    end
    it "should include it's own microposts" do
      Micropost.from_users_followed_by(@user).include?(@user_post).should be_true
    end
    it "shouldn't include the third users micropost" do
      Micropost.from_users_followed_by(@user).include?(@third_post).should be_false
    end

  end

end
