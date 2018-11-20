class AttendanceReportController < ApplicationController
  include AttendanceReportHelper
  before_action :authenticate
  def select_member
    @members = membership_list
  end

  def generate
    record_id, @member_name = params[:member].split(',')
    @events = events_for_member(record_id)
  end

  def generate_pdf
    record_id, @member_name = params[:member].split(',')
    @events = events_for_member(record_id)

    render pdf: "#{@member_name}_attendance.pdf",
      disposition: "inline",
      template: 'attendance_report/generate_pdf.html.erb',
      layout: 'pdf.html.erb',
      dpi: '380',
      page_size: 'letter',
      orientation: 'Landscape'

    # html = render_to_string(:action => :generate_pdf, :layout => 'pdf.html')
    # pdf = ::WickedPdf.new.pdf_from_string(html)
    #
    # send_data(
    #   pdf,
    #   :filename => "#{@member_name}_attendance.pdf",
    #   :disposition => 'attachment'
    #  )
  end
end
