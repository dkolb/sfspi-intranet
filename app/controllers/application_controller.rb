class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?, :is_admin?

  rescue_from 'Airrecord::Error' do |e|
    if e.message.include? 'HTTP 404'
      raise ActiveRecord::RecordNotFound.new("Could not find event.")
    else
      raise e
    end
  end


  def authorize_admin
    redirect_to :login unless user_signed_in?
    unless is_admin?
      flash[:error] = 'You do not have permission to do do that!'
      redirect_to root_path
    end
  end

  def is_admin?
    user_signed_in? && current_user.roles.include?('admin')
  end

  def authenticate
    redirect_to :login unless user_signed_in?
  end

  def authenticate_api
    head 403 unless user_signed_in?
  end

  def current_user
    @currrent_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end
end
