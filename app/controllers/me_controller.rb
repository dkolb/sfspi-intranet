class MeController < ApplicationController
  include MeHelper
  include SharedFormHelper
  before_action :authenticate

  def show
    @user = current_user
    @member = member_for(@user)
    @e_contact = emergency_contact_for(@member)
    @profile = OpenStruct.new({ 
      member: @member, 
      e_contact: @e_contact 
    })
    @paths = paths
  end

  def update_profile
    changes_saved = false
    member = member_for(current_user)
    emergency_contact = emergency_contact_for(member)
    params[:profile][:member][:path] = [ params[:profile][:member][:path] ]

    member.set_from_mapped_fields(params[:profile][:member])
    changes_saved ||= member.changed?
    member.save
    
    emergency_contact.set_from_mapped_fields(params[:profile][:emergency_contact])

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

    redirect_to action: "show"
  end
end
