class EventsController < ApplicationController
  include EventsHelper
  include SharedFormHelper
  before_action :authenticate, except: [ :by_date, :by_date_rang  ]
  before_action :authenticate_api, only: [ :by_date, :by_date_range ]

  def by_date
    render json: events_for_date(params[:date])
  end

  def index
    go_to_form = params.permit(go_to: {}).to_h.fetch(:go_to, nil)
    if params[:start_date]
      start_date = params[:start_date].to_date
    elsif go_to_form
      parse_date_parts(go_to_form, :date)
      params[:start_date] = start_date = go_to_form[:date]
    else
      params[:start_date] = start_date = Time.zone.today
    end
    @events = Event.for_month(start_date)
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
    if is_admin? || is_secretary?
      @records = Member.all.map { |m| [m.pseudonym, m.id] }
      @selected = @records.find { |r| r[1] =~ /#{@reporting_member.id}/ }
    end
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
        if is_admin? || is_secretary?
          @records = Member.all.map { |m| [m.pseudonym, m.id] }
          @selected = @records.find { |r| r[1] =~ /#{@reporting_member.id}/ }
        end
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
      reporting_member_raw: [ @member.id ],
      form_filed: true
    })
    if is_admin? || is_secretary?
      @records = Member.all.map { |m| [m.pseudonym, m.id] }
      @selected = @records.find { |r| r[1] =~ /#{@reporting_member.id}/ }
    end
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
      event_fields = @event.fields.clone
      event_fields['id'] = @event.id
      EventsMailer.with(event: event_fields).new_event_email.deliver_later
      flash[:success] = "Point Nun Form created!"
      redirect_to action: :show, id: @event.id
    else
      flash[:error] = @event.errors.messages.map do |field_name, message|
        "#{field_name.to_s.titleize} #{message.join(",")}"
      end
      if is_admin? || is_secretary?
        @records = Member.all.map { |m| [m.pseudonym, m.id] }
        @selected = @records.find { |r| r[1] =~ /#{@reporting_member.id}/ }
      end
      render 'new'
    end
  end
end
