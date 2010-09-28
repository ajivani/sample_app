module SessionsHelper
  def sign_in(user)
    #cookies.permanent.signed[:remember_token] = [user.id, user.salt] #the remember token 'hash'  stores the user id. --uses the salt to make it unique and permanent for #makes a cookie with user_id and the salt (salt to make it unique and non fradulant for each individual user)
    session[:user_info] = [user.id, user.salt]
    current_user = user #current user can now be seen in controllers and views!
  end
  def sign_out
    #cookies.delete(:remember_token)
    session[:user_info] = nil
    self.current_user = nil #use self.current_user = nil if the first line doesn't work for tests, since self refers to the controller
  end
  
  def current_user=(user)
    @current_user = user
  end
  #need a way for the correct current user to be displayed while moving around on web pages#disapearing when we more aroudn the web pages
  #way to track the current user, in the view as well as the controllers
  def current_user
    @current_user ||= user_from_remember_token  #either it's already loaded, or it will find it from the cookies hash
  end
  def signed_in?
   !current_user.nil?
  end
  
  private 
  #current_user -- session user corresponding to the cookie created by this code
  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end
  def remember_token
    session[:user_info] || [nil,nil]
    #cookies.signed[:remember_token] || [nil,nil]
  end
end
