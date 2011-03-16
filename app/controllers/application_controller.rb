class ApplicationController < ActionController::Base
  protect_from_forgery

  def init_api
    if session[:user]
     @api = session[:api] 
     @user = session[:user]
    else
      redirect_to login_path
    end
  end

end
