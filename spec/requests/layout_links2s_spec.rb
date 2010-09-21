require 'spec_helper'

describe "LayoutLinks2s" do
    describe "GET /layout_links2s" do
    
      it "works! (now write some real specs)" do
      get '/home'
    end
    it "should have a home page at '/home'" do
      get '/home'
     # response.should be_success
      #response.should equal :success 
      #response.should have_selector('title', "Home")
    end

  end
end
