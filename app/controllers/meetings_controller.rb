class MeetingsController < ApplicationController
  include MeetingsHelper
  include SharedFormHelper
  before_action :authenticate, only: [:index, :show]
  before_action :authorize_secretary, only: [:edit, :update, :new, :create]
  before_action :authenticate_api, only: [:by_date_range]

  def by_year
    render json: meetings_by_year(params[:year])
  end

  def index
  end

  def show
    @meeting = Meeting.find(params[:id])
    @can_edit = can_edit?
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    meeting_params = params.permit(meeting: {}).to_h.fetch(:meeting)
    clean_blanks_from_form(meeting_params)
    parse_date_parts(meeting_params, :date)

    @meeting = Meeting.find(params[:id])
    @meeting.assign_attributes(meeting_params)

    if @meeting.changed?
      if @meeting.valid?
        @meeting.save
        flash[:success] = "Saved meeting changes!"
      else
        flash[:error] = @meeting.errors.messages.map do |field_name, message|
          "#{field_name.to_s.titleize} #{message.join(",")}"
        end
      end
    else
      flash[:info] = "No changes detected."
    end

    redirect_to action: :show, id: @meeting.id
  end

  def new
    @meeting = Meeting.empty
    @meeting.date = Time.zone.today
  end

  def create
    meeting_params = params.permit(meeting: {}).to_h.fetch(:meeting)
    clean_blanks_from_form(meeting_params)
    parse_date_parts(meeting_params, :date)
    @meeting = Meeting.new_assign_attributes(meeting_params)

    if @meeting.valid?
      @meeting.save
      fields = @meeting.fields.clone
      fields['id'] = @meeting.id
      MeetingsMailer.with(meeting: fields).new_meeting_email.deliver_later
      flash[:success] = "Meeting created!"
      redirect_to action: :show, id: @meeting.id
    else
      flash[:error] = @meeting.errors.messages.map do |field_name, message|
        "#{field_name.to_s.titleize} #{message.join(",")}"
      end
      render 'new'
    end
  end

  private

  def meetings_by_year(year)
    Meeting.for_year(year).map do |m|
      {
        type: m.type,
        date: date_display(m.date),
        href: meeting_path(m.id)
      }
    end
  end
end
