module MembersHelper
  def emergency_contact_for(member)
    if member.nil?
      c = nil
    else
      c = member.emergency_contact
      c = EmergencyContact.empty if c.nil?
      c['Member'] = [ member.id ]
    end
    c
  end

  def paths
    Path.all
  end

  def can_edit?
    params[:id] == current_user.record_link || is_admin?
  end
end
