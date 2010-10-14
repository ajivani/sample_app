class RelationshipsController < ApplicationController
before_filter :authenticate

#users the relationships 
def create
  @user = User.find(params[:relationship][:followed_id]) #@user = User.find(params[:id])  #this doesn't work, but do it to see the params being dumped
  current_user.follow!(@user)
  respond_to do |format|
    format.html {redirect_to user_path(@user)}
    format.js #calls the file create.js.erb 
  end
end

def destroy
  @user = Relationship.find(params[:id]).followed
  current_user.unfollow!(@user)
  respond_to do |format|
    format.html { redirect_to @user }
    format.js #calls the file  with the action destroy.js.erb 
  end
end


end
