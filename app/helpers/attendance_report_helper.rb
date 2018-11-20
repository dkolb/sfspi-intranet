module AttendanceReportHelper
  def membership_list
    MembershipBase::Members.all
      .select { |m| m['Status'] != 'Retired' }
      .map do |m|
        {
          name: m['Pseudonym'],
          record: m.id
        }
      end
  end

  def events_for_member(record_id)
    MembershipBase::Members.find(record_id)
      .events_attended
      .select { |e| e['If Last 12 Months'] = 1 }
      .sort_by { |e| DateTime.iso8601(e['Date']) }
      .map { |e| event_as_hash(e) }
  end

  def event_as_hash(event)
    reporting_member = event['Reporting Member'].nil? ?
      nil : event.reporting_member['Pseudonym']

    point_members = event['Point Members'].nil? ?
      nil : event.point_members.map { |e| e['Pseudonym'] }
    {
      date: event['Date'],
      name: event['Name of Event'],
      venue: event['Venue'],
      purpose: event['Purpose of Event'],
      point_members: point_members,
      reporting_member: reporting_member
    }
  end
end
