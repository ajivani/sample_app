class UsersController < ApplicationController
  #order matters on before filters
  before_filter :authenticate, :except=>[:show, :new, :create] #before_filter :authenticate, :only=>[:index,:edit,:update,:destroy, :following, :followers]
  before_filter :correct_user, :only=>[:edit,:update]
  before_filter :admin_user, :only => :destroy
  before_filter :already_signed_in, :only=>[:new, :create]  
  #before_filter :authenticate, :except=>[:show, :new, :create] #order matters...the correct_user before filter is applied first here, so this never even gets applied, if you move it up then it will be applied
  def following
    @title = "Following"
    @user = User.find(params[:id])  
    @users = @user.following.paginate(:page=> params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page=>params[:page])
    render 'show_follow'
  end

  def destroy
    user = User.find(params[:id])
    if !(current_user == user)
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    else
      flash[:error] = "Cannot delete self. You must pick a user other than yourself to delete."
      redirect_to users_path
    end    
  end

  def index
    @title = "All users" 
    @users = User.paginate(:page=>params[:page])
    #@users = User.find(:all)
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def show#or just users/1 since the 'show' is implicit for GET requests.
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page=>params[:page])
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

  def edit
   @title = "Edit user" ## @user = User.find(params[:id]) #since we already called this in correct_user
  end

  def update
    if @user.update_attributes(params[:user])#correct_user called before every edit or update so we don't need the @user again #is#@user = User.find(params[:id])
      flash[:success] = 'Profile updated'
      redirect_to user_path(@user)
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user) #same thing #redirect_to(root_path) if !(current_user == @user)
  end
  def admin_user
    redirect_to(root_path) if (!current_user.admin?)
  end
  def already_signed_in
    redirect_to(users_path) if (!current_user.nil? && !current_user.admin?)
  end
  
  #we need this in the microposts controller too so we just moved it to the session helper file
  #def authenticate
   # deny_access unless signed_in?
  #end
  

end

