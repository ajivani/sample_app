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


  

  end
end
