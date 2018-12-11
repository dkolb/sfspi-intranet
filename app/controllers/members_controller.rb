class MembersController < ApplicationController
  include SharedFormHelper
  include MembersHelper

  before_action :authenticate

  def index
    @members = Member.yellow_pages_view
    respond_to do |format|
      format.html
      format.json { render json: @members }
    end
  end

  def show
    @user = current_user
    @member = member_for(@user)
    @e_contact = emergency_contact_for(@member)
    @paths = paths
  end

  def edit
    unless can_edit?
      flash[:error] = "You do not have permission to edit this member!"
      redirect_to member_path(params[:id])
    end
    @user = current_user
    @member = member_for(@user)
    @e_contact = emergency_contact_for(@member)
    @paths = paths
  end

  def update
    unless can_edit?
      flash[:error] = "You do not have permission to edit this member!"
      redirect_to member_path(params[:id])
    end

    profile_params = params.permit(profile: {}).to_h.fetch(:profile)
    clean_blanks_from_form(profile_params)

    changes_saved = false
    member = member_for(current_user)
    emergency_contact = emergency_contact_for(member)

    member.assign_attributes(profile_params[:member])
    changes_saved ||= member.changed?
    member.save
    
    emergency_contact.assign_attributes(profile_params[:emergency_contact])

    if emergency_contact.new_record?
      emergency_contact.member = [ member.id ]
    end

    changes_saved ||= emergency_contact.changed?

    emergency_contact.save

    if changes_saved
      flash[:success] = "Updated your records!"
    else
      flash[:notice] = "No changes detected."
    end

    redirect_to action: :show, id: member.id
  end
end
