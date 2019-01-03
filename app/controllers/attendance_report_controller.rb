class AttendanceReportController < ApplicationController
  include AttendanceReportHelper

  before_action :authenticate
  def select_member
    @records = Member.all.map { |m| [ m.pseudonym, m.id ] }
    @selected = @records.find { |r| r[1] =~ /#{current_user.record_link}/ }
    @records = [ @selected ] unless is_admin? || is_secretary?
  end

  def generate
    @record_id = params[:member][:selection]
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
