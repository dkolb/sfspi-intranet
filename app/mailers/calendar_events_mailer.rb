class CalendarEventsMailer < ApplicationMailer
  default to: ENV['CALENDAR_EVENT_CREATED_EMAIL']

  def new_calendar_event_email
    @calendar_event_id = params[:calendar_event].delete 'id'
    @calendar_event = CalendarEvent.new(params[:calendar_event])
    mail(subject: "New Calendar Event made: #{@calendar_event.name}")
  end
end
