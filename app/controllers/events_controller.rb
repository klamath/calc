class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /calendar
  def calendar
    #@event = Event.find(params[:id])
    @month = Time.now.beginning_of_month.to_date
    respond_to do |format|
      format.html { render partial: 'calendar' }
    end
  end

end
