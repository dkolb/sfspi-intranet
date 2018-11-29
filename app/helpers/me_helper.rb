module MeHelper
  def member_for(user)
    if user.record_link.nil?
      nil
    else
      MembershipBase::Members.find(user.record_link)
    end
  end

  def emergency_contact_for(member)
    if member.nil?
      c = nil
    else
      c = member.emergency_contact
      c = MembershipBase::EmergencyContacts.new({}) if c.new_record?
      c['Member'] = [ member.id ]
    end
    c
  end

  def paths
    MembershipBase::Paths.all
      .map { |p| [ p['Name'], p.id ] }
  end

  def user_input_tag_for(type, label_text, field_name, value)
    input_tag_for 'user', type, label_text, field_name, value
  end

  def contact_input_tag_for(type, label_text, field_name, value)
    input_tag_for 'emergency_contact', type, label_text, field_name, value
  end

  def input_tag_for(object, type, label_text, field_name, value)
    render partial: 'form_row_input',
      locals: {
        object: object,
        type: type,
        label_text: label_text, 
        field_name: field_name,
        value: value
      }
  end
    
  def user_select_tag_for(label_text, field_name, options, selected, blank_text)
    select_tag_for 'user',
                   label_text,
                   field_name,
                   options,
                   selected, 
                   blank_text
  end

  def select_tag_for(object, label_text, field_name, options, selected, 
                     blank_text)
    render partial: 'form_select',
      locals: {
        object: object,
        label_text: label_text,
        field_name: field_name,
        options: options,
        selected: selected,
        blank_text: blank_text,
      }
  end
end
