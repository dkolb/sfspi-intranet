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
      @user = User.find_from_auth_hash(auth)

      if @user.nil?
        @user = User.create_from_auth_hash(auth)
        UserMailer.with(user: @user).new_user_email.deliver_later
      else
        @user.update_from_auth_hash(auth)
      end

      session[:user_id] = @user.id
      session[:auth_provider] = @user.provider
      redirect_to auth_origin
    end
  end

  def destroy
    provider = session[:auth_provider]

    if provider == 'microsoft_v2_auth'
      redirect_arg = o365_logout_url
    else
      redirect_arg = root_path
    end

    session[:user_id] = nil
    session[:auth_provider] = nil
    Rails.logger.warn("Redirecting to #{redirect_arg}")
    redirect_to redirect_arg
  end

  def auth_failure
    flash[:error] = 'Something went wrong during authentication. Sorry.'
    redirect_to root_path
  end

  private 
  def auth_origin
    request.env['omniauth.origin'] || session[:auth_origin] || root_path
  end

  def o365_logout_url
    "https://login.windows.net/common/oauth2/logout?" \
      "post_logout_redirect_uri=#{request.base_url}"
  end
  
  def google_logout_url
  end
end
