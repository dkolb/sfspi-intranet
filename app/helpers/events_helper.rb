module EventsHelper
  def events_for_date(date)
    events = Event.all(
      filter: "{Date} = DATETIME_PARSE('#{date}')"
    )

    events.map do |e|
      {
        name: e.name,
        venue: e.venue,
        id: events_edit_by_id_path(e.id)
      }
    end
  end

  def events_for_date_range(start_date, end_date)
    events = Event.all(
      filter: "AND({Date} >= '#{start_date}', {Date} < '#{end_date}')"
    )

    events.map do |e|
      {
        name: e.name,
        venue: e.venue,
        date: e.date,
        id: events_edit_by_id_path(e.id)
      }
    end
  end

  def active_member_records
    @active_member_records ||= Member.all(
      filter: '{Status} = "Active"',
      sort: {'Pseudonym' => 'asc'}
    )
  end

  def can_edit
    is_admin? || current_user.record_link == @event.reporting_member_raw
  end
end
