class UsersController < ApplicationController
  def new
    @title = "Sign up"
  end
  #or just users/1 since the 'show' is implicit for GET requests.
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
end
