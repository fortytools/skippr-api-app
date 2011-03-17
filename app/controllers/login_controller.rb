class LoginController < ApplicationController

  def login

  end

  def do
    user = params[:user][:name]
    secret = params[:user][:secret]
    client = params[:user][:client]

    if exec_login(client, user, secret)
      flash[:success] = "Login success"
      redirect_to home_path
    else
      flash[:error] = "Login failed"
      redirect_to login_path
    end
  end

  def auto
    session.destroy
    client = params[:client]
    user_key = params[:user]
    signature = params[:signature]
    user = SkipprUser.find_by_key(user_key)
    
    if user.nil?
      redirect_to login_path
    else
      valid_sign_src = user.secret + SkipprApi::AuthFactory.instance.app_secret
      valid_sign = Digest::MD5.hexdigest(valid_sign_src)
      if valid_sign == signature 
        if exec_login(client, user.key, user.secret)
          redirect_to home_path
        else
          redirect_to login_path
        end
      else
        redirect_to login_path
      end
    end
    

  end

  private 
  
  def exec_login(client, user, secret)
    auth = SkipprApi::AuthFactory.for_user(client, user, secret)
    if auth.valid?
      session[:user] = auth
      session[:api] = SkipprApi::ApiFactory.create_api(auth)
      true
    else
      false
    end

  end


end
