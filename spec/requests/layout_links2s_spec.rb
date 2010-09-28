require 'spec_helper'

describe "LayoutLinks2s" do
    describe "GET /layout_links2s" do
      it "works! (now write some real specs)" do
        get '/home'
      end
      it "should have a home at '/'" do
        get '/'
        response.should be_success
        response.should have_selector('title', :content=>"Home")
      end
      it "should have a home page at '/home'" do
        get '/home'
        visit root_path
        click_link "Contact"
        response.should have_selector("title", :content=>"Contact")
      # response.should be_success
        #response.should equal :success 
        #response.should have_selector('title', "Home")
      end
      it"should have the right links on the layout" do
        visit root_path
        click_link "About"
        response.should have_selector('title', :content => "About")
        click_link "Help"
        response.should have_selector('title', :content=> "Help")
        click_link "Contact"
        response.should have_selector('title', :content=> "Contact")
      end
      it"should have the right links on the layout another test" do
        visit root_path
        click_link "Home"
        response.should have_selector('title', :content=>"Home")
        click_link "Sign up now!"
        response.should have_selector('title', :content=>" | Sign up")
      end
    end#get

    describe "when not signed in" do
      it "should have a signin path" do
        visit root_path
        response.should have_selector("a", :href=>signin_path,
                                            :content=>"Sign in")
      end
    end #not signed in
    
    describe "when signed in" do
      before(:each) do
        @user = Factory(:user)
        integration_sign_in(@user)
      end
      it "should have a signout link" do
        visit root_path
        response.should have_selector("a", :href=>signout_path,
                                            :content=>"Sign out")
      end
      it "should have a profile link" do
        visit root_path
        response.should have_selector("a", :href=> user_path(@user),
                                            :content=> "Profile")
      end

    end#when signed in

end
