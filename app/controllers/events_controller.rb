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
    @member = member_for(current_user)
    if params[:id].nil?
      @event = MembershipBase::Event.new({})
    else
      begin
        @event = MembershipBase::Event.find(params[:id])
      rescue Aireccord::Error => e
        if e.message.include? 'HTTP 404'
          @event = MembershipBase::Event.find(params[:id])
        else
          raise e
        end
      end
    end
  end

  def edit_do
    if params[:id]
      @event = MembershipBase::Event.find(params[:id])
      @event.set_from_mapped_fields(params[:event], set_empty: false)
    else
      @event = MembershipBase::Event.new_from_mapped_fields(params[:event])
    end

    if @event.valid?
      @event.save
      flash[:success] = "Created new event record #{@event.id}"
      redirect_to controller: 'events', action: 'edit', id: @event.id
    else
      flash[:error] = @event.errors.messages.map do |field_name, message|
        "#{field_name.to_s.titleize} #{message.join(",")}"
      end
      render 'edit'
    end
  end
end
