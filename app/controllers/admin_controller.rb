class AdminController < ApplicationController
  include AdminHelper
  before_action :authorize_admin

  def users
    @users = User.order(:display_name)
    @members = member_records
  end

  def update_users
    changes = false
    params[:update_user_link].each do |id, record|
      u = User.find(id)
      u.record_link = record.empty? ? nil : record
      if u.changed?
        changes = true
        u.save
      end
    end
    if changes
      flash[:sucess] = "Changes saved!"
    else
      flash[:info] = "No changes detected."
    end
    redirect_to admin_users_get_path
  end
end
