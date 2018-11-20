class AttendanceReportController < ApplicationController
  include MeHelper
  include AttendanceReportHelper
  before_action :authenticate
  def select_member
    @records = member_records.map { |r| [ r[0], r.join('|') ] }
    @selected = @records.find { |r| r[1] =~ /#{current_user.record_link}/ }
  end

  def generate
    @member_name, record_id = params[:member][:selection].split('|')
    @events = events_for_member(record_id)
    @meetings = meetings_for_member(record_id)
    @gen_html = true
  end

  def generate_pdf
    @member_name, record_id = params[:member].split('|')
    @events = events_for_member(record_id)
    @meetings = meetings_for_member(record_id)
    @gen_html = false

    render pdf: "#{@member_name}_attendance.pdf",
      disposition: "inline",
      template: 'attendance_report/generate.html.erb',
      layout: 'pdf.html.erb',
      dpi: '380',
      page_size: 'letter',
      orientation: 'Landscape'
  end
end
