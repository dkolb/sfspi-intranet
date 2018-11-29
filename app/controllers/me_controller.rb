class MeController < ApplicationController
  include MeHelper
  before_action :authenticate

  def show
    @user = current_user
    @member = member_for(@user)
    @emergency_contact = emergency_contact_for(@member)
    @paths = paths
  end

  def update_profile
    changes_saved = false
    member = member_for(current_user)

    {
      'user' => member,
      'emergency_contact' => emergency_contact_for(member)
    }.each do |form_param, record|
      next if params[form_param].nil?
      original_param = "original_#{form_param}"
      air_name_param = "air_name_#{form_param}"

      params[form_param].each do | key, new_value |
        old_value = params[original_param][key]
        airtable_name = params[air_name_param][key]

        if old_value != new_value
          record[airtable_name] = new_value
        end
      end

      if !record.updated_keys.empty?
        record.save
        changes_saved ||= true
      end
    end

    if changes_saved
      flash[:success] = "Updated your records!"
    else
      flash[:notice] = "No changes detected."
    end

    redirect_to action: "show"
  end
end
