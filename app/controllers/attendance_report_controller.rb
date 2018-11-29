class AttendanceReportController < ApplicationController
  include AttendanceReportHelper
  include AdminHelper #for member_records

  before_action :authenticate
  def select_member
    @records = member_records.map { |r| [ r[0], r.join('|') ] }
    @selected = @records.find { |r| r[1] =~ /#{current_user.record_link}/ }
    @records = [ @selected ] unless is_admin?
  end

  def generate
    @member_name, @record_id = params[:member][:selection].split('|')
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
      template: 'attendance_report/generate.html.erb',
      layout: 'pdf.html.erb',
      dpi: '200',
      page_size: 'letter',
      orientation: 'Landscape'
  end
end
