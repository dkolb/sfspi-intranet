module AttendanceReportHelper
  def member_record(record_id)
      @member_record ||= Member.find(record_id)
  end

  def events_for_member(record_id)
    member_record(record_id)
      .events_attended
      .select { |e| e.last_12_months? }
      .sort_by { |e| e.date }
      .map { |e| event_as_hash(e) }
  end

  def event_as_hash(event)
    point_members = event.point_members_raw.nil? ?
      nil : event.point_members.map { |e| e['Pseudonym'] }
    reporting_member = event.reporting_member_raw.nil? ?
      nil : event.reporting_member.pseudonym
    {
      date: event.date,
      name: event.name,
      venue: event.venue,
      purpose: event.purpose,
      point_members: point_members,
      reporting_member: reporting_member,
      href: event_path(event.id)
    }
  end

  def meetings_for_member(record_id)
    member_record(record_id)
      .meetings_attended
      .select { |m| m.last_12_months? }
      .select { |m| m.type == 'GM' }
      .sort_by { |m| m.date }
      .map { |m| meeting_as_hash(m) }
  end

  def meeting_as_hash(meeting)
    {
      date: meeting.date,
      type: meeting.type,
      href: meeting_path(meeting.id)
    }
  end
end
