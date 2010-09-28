class UsersController < ApplicationController
  def new
    @title = "Sign up"
    @user = User.new
  end
  #or just users/1 since the 'show' is implicit for GET requests.
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = 'Welcome to the Sample App!'
      sign_in @user
      redirect_to @user #user_path(@user)
    else
      @title = "Sign up"
      @user.password = ''
      @user.password_confirmation = ''
      render 'new' #render works for actions #as well as partials 
    end
  end

end

