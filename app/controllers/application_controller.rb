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

  DATE_PARAM_PART_REGEX = /^date\(\d+([if])\)/
  def parse_date_parts(form_params, field_name)
    result = form_params.each_with_object({args: [], delete: []}) do |(k, v), res| 
      matches = /^#{field_name.to_s}\((?<index>\d+)(?<type>[if])\)/.match(k)
      next if matches.nil?
      index = matches[:index].to_i - 1

      case matches[:type]
      when 'i'
        res[:args][index] = v.to_i
      when 'f'
        res[:args][index] = v.to_f
      else
        res[:args][index] = v
      end

      res[:delete] << k
    end

    result[:delete].each do |key|
      form_params.delete key
    end

    form_params[field_name] = Date.new(*result[:args])
  end

  def clean_blanks_from_form(form_params)
    form_params.reject! { |_, v| v == '' }
  end
end
