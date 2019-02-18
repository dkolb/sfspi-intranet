module EventsHelper
  def events_for_date(date)
    Event.for_date(date).map do |e|
      {
        name: e.name,
        venue: e.venue,
        href: event_path(e.id)
      }
    end
  end

  def active_member_records
    @active_member_records ||= Member.all(
      filter: '{Status} = "Active"',
      sort: {'Pseudonym' => 'asc'}
    )
  end

  def can_edit?
    is_admin? || current_user.record_link == @event.reporting_member_raw
  end
end
