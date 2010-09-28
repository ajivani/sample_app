require 'spec_helper'

describe "Users" do
  describe "Signup" do
    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",     :with=>""
          fill_in "Email",    :with=>""
          fill_in "Password", :with=>""
          fill_in "Confirm Password", :with=>""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end#failure

    describe "success" do
      it "should make a new user with valid input" do
        lambda do
          visit signup_path
          fill_in "Name",     :with=>"ameen"
          fill_in "Email",    :with=>"ameen@email.com"
          fill_in "Password", :with=>"foobar"
          fill_in "Confirm Password", :with=>"foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content=> "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end#success
  end#signup

  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        user = Factory(:user)
        visit signin_path
        fill_in :email, :with=>user.email
        fill_in :password, :with=>""
        click_button
        response.should have_selector("div.flash.error", :content=>"Invalid")
      end
    end#failure
    describe "success" do
      it "should let a user sign in" do
        user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end#success

  end#sign in/out

end
