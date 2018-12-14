class MeetingsMailer < ApplicationMailer
  default to: ENV['MEETING_CREATED_EMAIL']

  def new_meeting_email
    @meeting_id = params[:meeting].delete 'id'
    @meeting = Meeting.new(params[:meeting])
    mail(subject: "New Meeting Attendance Reported: #{@meeting.date}")
  end
end
