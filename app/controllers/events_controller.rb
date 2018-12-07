class EventsController < ApplicationController
  include EventsHelper
  include SharedFormHelper
  include MeHelper
  before_action :authenticate, only: [ :select_event, :edit, :edit_do ]
  before_action :authenticate_api, only: [ :by_date, :by_date_range ]

  def by_date
    render json: events_for_date(params[:date])
  end

  def by_date_range
    render json: events_for_date_range(params[:start_date], params[:end_date])
  end

  def select_event
  end

  def edit
    if params[:id].nil?
      @member = member_for(current_user)
      @reporting_member = @member
      @event = Event.new_from_mapped_fields({
        reporting_member_raw: [ @member.id ]
      })
    else
      @event = Event.find(params[:id])
      @reporting_member = @event.reporting_member_raw.nil? ?
        Member.empty : @event.reporting_member
    end
  end

  def edit_do
    if params[:id]
      @event = Event.find(params[:id])
      @event.set_from_mapped_fields(params[:event], set_empty: false)
    else
      @event = Event.new_from_mapped_fields(params[:event])
    end

    @event.reporting_member_raw = [ @event.reporting_member_raw ]

    if @event.new_record?
      @reporting_member = member_for(current_user)
    else
      @reporting_member = @event.reporting_member || Member.empty
    end

    if @event.changed?
      new_record = @event.new_record?
      if @event.valid?
        @event.save
        if new_record
          flash[:success] = "Created new event record #{@event.id}"
        else
          flash[:success] = "Saved event changes!"
        end
        redirect_to controller: 'events', action: 'edit', id: @event.id
      else
        flash[:error] = @event.errors.messages.map do |field_name, message|
          "#{field_name.to_s.titleize} #{message.join(",")}"
        end
        render 'edit'
      end
    else
      flash[:info] = "No changes detected."
      render 'edit'
    end
  rescue Airrecord::Error => e
    if e.message.include? 'HTTP 404'
      raise ActiveRecord::RecordNotFound, "Record not found."
    end
  end
end
