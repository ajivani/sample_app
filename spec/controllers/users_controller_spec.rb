require 'spec_helper' 

describe UsersController do
  render_views
  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App "
  end
  
  describe "GET show" do
    before(:each) do
      @user = Factory(:user)
    end
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
      # assigns(:user),nil,nil,@user,nil,nil,@user.to_param,nil,nil,params
    end
    it 'should have the right title' do
      get :show, :id=>@user
      response.should have_selector('title', :content=>@user.name)
    end
    it 'should have the users name on the page' do
      get :show, :id=>@user
      response.should have_selector('h1', :content=>@user.name)
    end
    it 'should have a profile image' do
      get :show, :id=>@user
      response.should have_selector("h1>img", :class=>'gravatar')
    end
  end #GET show


  describe "GET 'new'" do    
    it "should be successful" do
      get 'new'
      response.should have_selector("title", :content=>"Sign up")
      response.should be_success
      
    end
    it "should have right title" do
      get 'new'
      response.should have_selector("title",
                                    :content=> @base_title + "| Sign up")
    end

  end
end
