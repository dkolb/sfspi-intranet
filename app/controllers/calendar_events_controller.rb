class CalendarEventsController < ApplicationController
  include SharedFormHelper
  include CalendarEventsHelper
  before_action :set_calendar_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate
  before_action :authorize_calendar_admin, only: [:destroy]

  # GET /calendar_events
  # GET /calendar_events.json
  def index
    if params[:start_date]
      start_date = params[:start_date].to_date
    else
      start_date = Time.zone.today
    end
    @calendar_events = CalendarEvent.for_month(start_date) + birthday_events
  end

  # GET /calendar_events/1
  # GET /calendar_events/1.json
  def show
  end

  # GET /calendar_events/new
  def new
    @calendar_event = CalendarEvent.empty
  end

  # GET /calendar_events/1/edit
  def edit
  end

  # POST /calendar_events
  # POST /calendar_events.json
  def create
    @calendar_event = CalendarEvent.new_assign_attributes(calendar_event_params)

    if @calendar_event.valid?
      @calendar_event.save if @calendar_event.changed?
      calendar_fields = @calendar_event.fields.clone
      calendar_fields['id'] = @calendar_event.id
      if @calendar_event.type == 'Event'
        CalendarEventsMailer.with(calendar_event: calendar_fields)
          .new_calendar_event_email
          .deliver_later
      end
      flash[:info] = 'Calendar event sucessfully created.'
      redirect_to action: :show, id: @calendar_event.id 
    else
      render :new 
    end
  end

  # PATCH/PUT /calendar_events/1
  # PATCH/PUT /calendar_events/1.json
  def update
    @calendar_event.assign_attributes(calendar_event_params)
    if @calendar_event.changed? && @calendar_event.valid?
      @calendar_event.save
      flash[:info] = 'Calendar event was successfully updated.'
      redirect_to action: :show, id: @calendar_event.id 
    else
      render :edit
    end
  end

  # DELETE /calendar_events/1
  # DELETE /calendar_events/1.json
  def destroy
    @calendar_event.destroy
    respond_to do |format|
      flash[:info] = 'Calendar event was successfully removed.'
      format.html { redirect_to calendar_events_url}
      format.json { head :no_content }
    end
  end

  def generate_pdf
    @start_date = Time.zone.today.beginning_of_month
    @year = @start_date.year
    @end_date = (@start_date + 11.months).end_of_month
    @calendar_events = CalendarEvent.for_range(@start_date, @end_date) + birthday_events
    @months = months_in_events(@calendar_events)
    if params[:html] == 'true'
      render 'calendar_events/pdf_calendar', layout: 'pdf'
    else
      render pdf: "sfspi_calendar.pdf",
         disposition: 'inline',
         template: 'calendar_events/pdf_calendar',
         layout: 'pdf',
         dpi: '200',
         page_size: 'letter',
         orientation: 'Portrait',
         disable_internal_links: true,
         disable_external_links: true
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_calendar_event
    @calendar_event = CalendarEvent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def calendar_event_params
    the_params = params.permit(calendar_event: {})
      .to_h
      .fetch(:calendar_event)
    clean_blanks_from_form(the_params)

    parse_date_parts(the_params, :start_time)
    parse_date_parts(the_params, :end_time)
    the_params
  end

  def birthday_events
    Member.active.map do |m|
      next if m.birthday.nil?
      c = CalendarEvent.empty
      date = Time.zone.local(
        year_for(m.birthday.month),
        m.birthday.month,
        m.birthday.day
      )
      c.start_time = date
      c.end_time = date
      c.all_day = true
      c.type = 'Birthday'
      c.name = "#{m.pseudonym} Birthday"
      c.approved = true
      c
    end.compact
  end

  def months_in_events(events)
    months = Set.new
    events.each_with_object(months) do |event, months|
      months.add(event.start_time.month)
      months.add(event.end_time.month)
    end
    months.sort.partition{ |m| m >= @start_date.month }.flatten
  end
end
