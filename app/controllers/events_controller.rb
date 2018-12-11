class EventsController < ApplicationController
  include EventsHelper
  include SharedFormHelper
  before_action :authenticate, only: [ :select_event, :edit, :edit_do ]
  before_action :authenticate_api, only: [ :by_date, :by_date_range ]

  def by_date
    render json: events_for_date(params[:date])
  end

  def by_date_range
    render json: events_for_date_range(params[:start_date], params[:end_date])
  end

  def index
  end

  def show
    @event = Event.find(params[:id])
    @reporting_member = @event.reporting_member_raw.nil? ?
      Member.empty : @event.reporting_member
  end

  def edit
    @event = Event.find(params[:id])
    @reporting_member = @event.reporting_member_raw.nil? ?
      Member.empty : @event.reporting_member
  end

  def update
    event_params = params.permit(event: {}).to_h.fetch(:event)
    clean_blanks_from_form(event_params)
    parse_date_parts(event_params, :date)

    @event = Event.find(params[:id])
    @event.assign_attributes(event_params)
    if @event.reporting_member_raw
      @event.reporting_member_raw = [ @event.reporting_member_raw ]
    end
    @reporting_member = @event.reporting_member || Member.empty

    if @event.changed?
      if @event.valid?
        @event.save
        flash[:success] = "Saved event changes!"
      else
        flash[:error] = @event.errors.messages.map do |field_name, message|
          "#{field_name.to_s.titleize} #{message.join(",")}"
        end
      end
    else
      flash[:info] = "No changes detected."
    end

    redirect_to action: :show, id: @event.id

  rescue Airrecord::Error => e
    if e.message.include? 'HTTP 404'
      raise ActiveRecord::RecordNotFound, "Record not found."
    else
      raise e
    end
  end

  def new
    @member = member_for(current_user)
    @reporting_member = @member
    @event = Event.new_assign_attributes({
      reporting_member_raw: [ @member.id ]
    })
  end

  def create
    event_params = params.permit(event: {}).to_h.fetch(:event)
    clean_blanks_from_form(event_params)
    parse_date_parts(event_params, :date)
    @event = Event.new_assign_attributes(event_params)
    @event.reporting_member_raw = [ @event.reporting_member_raw ]
    @reporting_member = member_for(current_user)

    if @event.valid?
      @event.save
      flash[:success] = "Point Nun Form created!"
      redirect_to action: :edit, id: @event.id
    else
      flash[:error] = @event.errors.messages.map do |field_name, message|
        "#{field_name.to_s.titleize} #{message.join(",")}"
      end
      render 'new'
    end
  end
end
