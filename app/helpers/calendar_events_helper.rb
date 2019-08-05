module CalendarEventsHelper
  def start_to_end_string(calendar_event)
    return '' if calendar_event.all_day
    return 'TBD' if calendar_event.start_time_tbd && calendar_event.end_time_tbd

    if calendar_event.start_time_tbd
      start_time = 'TBD'
    else
      start_time = calendar_event.start_time.strftime('%l:%M %p')
    end

    if calendar_event.end_time_tbd
      end_time = 'TBD'
    else
      end_time   = calendar_event.end_time.strftime('%l:%M %p')
    end

    "#{start_time} to #{end_time}"
  end

  def active_member_records
    @active_member_records ||= Member.active
  end

  def all_day_first(events)
    all_day_events, remaining_events = events.partition { |e| e.all_day }
    all_day_events + remaining_events
  end

  def event_additional_classes(event)
    classes = []
    classes << 'unapproved-event' if !event.approved
    classes << 'holiday-event' if event.type == 'Holiday'
    classes << 'normal-event' if event.type == 'Event'
    classes << 'birthday-event' if event.type == 'Birthday'
    classes
  end

  def year_for(month)
    reference = Time.zone.today
    if month >= reference.month
      return reference.year
    else
      return reference.year + 1
    end
  end

  def pdf_calendar_header(start_date, end_date)
    "SFSPI Calendar for " \
      "#{@start_date.strftime('%B %Y')} - #{@end_date.strftime('%B %Y')}"
  end
end
