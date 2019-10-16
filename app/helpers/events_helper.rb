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
    @active_member_records ||= Member.active
  end

  def can_edit?
    is_admin? || @event.reporting_member_raw.include?(current_user.record_link)
  end
end
