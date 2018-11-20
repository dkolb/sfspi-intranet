class SessionsController < ApplicationController
  VALID_DOMAIN = 'southfloridasisters.org'

  def create
    auth = request.env['omniauth.auth']
    email = auth.info.email
    domain = email.split('@')[1]

    if VALID_DOMAIN != domain
      flash[:error] = "Your login is not from our domain!"
      redirect_to root_path
      session[:user_id] = nil
    else
      @user = User.find_or_create_from_auth_hash(auth)
      session[:user_id] = @user.id
      redirect_to request.env['omniauth.origin'] || root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def auth_failure
    flash[:error] = 'Something went wrong during authentication. Sorry.'
    redirect_to root_path
  end
end
