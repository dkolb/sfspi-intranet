class EventsController < ApplicationController
  include EventsHelper
  include SharedFormHelper
  before_action :authenticate

  def by_date
    render json: events_for_date(params[:date])
  end

  def create_start
  end

  def create_do
  end

  def edit_start
  end

  def edit_by_id
  end
end
