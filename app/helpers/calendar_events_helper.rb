module CalendarEventsHelper
  def start_to_end_string(calendar_event)
    start_time = calendar_event.start_time.strftime('%l:%M %p')
    end_time   = calendar_event.end_time.strftime('%l:%M %p')

    "#{start_time} to #{end_time}"
  end

  def active_member_records
    @active_member_records ||= Member.all(
      filter: '{Status} = "Active"',
      sort: {'Pseudonym' => 'asc'}
    )
  end

end
