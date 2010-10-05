class MicropostsController < ApplicationController
  before_filter :authenticate#, :only=>[:create, :destroy] #in the sessionhelper.rb
  before_filter :authorized_user, :only=>[:destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost]) #build returns an object, in this case returns a micropost object
    #redirect_to(:root_path) if (@micropost.nil? || @micropost.content.blank? || @micropost.content.nil?)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private
  
  def authorized_user
    @micropost = Micropost.find(params[:id])
    redirect_to root_path if !(current_user?(@micropost.user))
  end

end
