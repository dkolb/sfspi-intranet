class MeController < ApplicationController
  include MeHelper
  before_action :authenticate
  def show
    @records = member_records
  end

  def update_profile
    if current_user.record_link == params[:update_profile_form][:record_link]
      flash[:notice] = 'No changes to profile detected.'
    else
      current_user.record_link = params[:update_profile_form][:record_link]
      current_user.save
      flash[:success] = 'Saved changes!'
    end

    redirect_to me_path
  end
end
