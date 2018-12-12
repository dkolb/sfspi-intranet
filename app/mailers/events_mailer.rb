class EventsMailer < ApplicationMailer
  default to: 'active@southfloridasisters.org'

  def new_event_email
    @event_id = params[:event].delete 'id'
    @event = Event.new(params[:event])
    mail(subject: "New Point Nun Report Form Filed: #{@event.name}")
  end
end
