class AttendanceReportController < ApplicationController
  include AttendanceReportHelper

  before_action :authenticate

  def summary
    @events = Event.within_12_months
    @meetings = Meeting.within_12_months
    @active = Member.active

    @counts = @active.map do |member|
      meeting_count = @meetings.select do |m|
        m.attendees_raw.include? member.id
      end.length

      event_count = @events.select do |e|
        (e.attendees_raw + e.point_members_raw).include? member.id
      end.length

      {
        id: member.id,
        pseudonym: member.pseudonym,
        meetings: meeting_count,
        events: event_count
      }
    end
  end

  def all_members
    @records = Member.all.map { |m| [ m.pseudonym, m.id ] }
    @selected = @records.find { |r| r[1] =~ /#{current_user.record_link}/ }
    @records = [ @selected ] unless is_admin? || is_secretary?
  end

  def generate
    if params[:member_id]
      @record_id = params[:member_id]
    else
      @record_id = params[:member][:selection]
    end
    @member_name = member_record(@record_id).pseudonym
    @events = events_for_member(@record_id)
    @meetings = meetings_for_member(@record_id)
    @gen_html = true
  end

  def generate_pdf
    @member_name = params[:member_name]
    @record_id = params[:record_id]
    @events = events_for_member(@record_id)
    @meetings = meetings_for_member(@record_id)
    @gen_html = false

    render pdf: "#{@member_name}_attendance.pdf",
      disposition: "inline",
      template: 'attendance_report/generate',
      layout: 'pdf',
      dpi: '200',
      page_size: 'letter',
      orientation: 'Landscape',
      disable_internal_links: true,
      disable_external_links: true
  end
end
