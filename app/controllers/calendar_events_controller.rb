class CalendarEventsController < ApplicationController
  include SharedFormHelper
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
    @calendar_events = CalendarEvent.for_month(start_date)
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
      CalendarEventsMailer.with(calendar_event: calendar_fields)
        .new_calendar_event_email
        .deliver_later
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
end
