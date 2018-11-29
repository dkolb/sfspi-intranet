module AttendanceReportHelper
  def member_record(record_id)
      MembershipBase::Members.find(record_id)
  end

  def events_for_member(record_id)
    member_record(record_id)
      .events_attended
      .select { |e| e['If Last 12 Months'] = 1 }
      .sort_by { |e| DateTime.iso8601(e['Date']) }
      .map { |e| event_as_hash(e) }
  end

  def event_as_hash(event)
    point_members = event['Point Members'].nil? ?
      nil : event.point_members.map { |e| e['Pseudonym'] }
    {
      date: event['Date'],
      name: event['Name of Event'],
      venue: event['Venue'],
      purpose: event['Purpose of Event'],
      point_members: point_members,
      reporting_member: envent['Reporting Member']
    }
  end

  def meetings_for_member(record_id)
    member_record(record_id)
      .meetings_attended
      .select { |m| m['If Last 12 Months'] == 1 }
      .select { |m| m['Meeting Type'] == 'GM' }
      .sort_by { |m| DateTime.iso8601(m['Date']) }
      .map { |m| meeting_as_hash(m) }
  end

  def meeting_as_hash(meeting)
    {
      date: meeting['Date'],
      type: meeting['Type']
    }
  end
end
