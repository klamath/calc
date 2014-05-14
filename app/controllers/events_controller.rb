class EventsController < ApplicationController

  def index

    @events = Event.paginate(conditions: {id: -1}, page: params[:page]) # empty result

    if params[:search_query] && params[:search_query][:date]
      @search_query = SearchQuery.new(params[:search_query])
      if @search_query.valid?
        @events = Event.from_to(@search_query.date_start, @search_query.date_end)
      end
    else
      @search_query = SearchQuery.new
    end

    respond_to do |format|
      format.html
    end
  end

  def calendar
    @month = get_month(params)
    respond_to do |format|
      format.html { render partial: 'calendar' }
    end
  end

  def events
    if params[:date]
      @search_query = SearchQuery.new({date: params[:date]})
      if @search_query.valid?
        @events = Event.from_to(@search_query.date_start, @search_query.date_end)
      end
    end

    respond_to do |format|
      format.json { render :json => @events.to_json }
    end
  end

  def view
    if params[:id]
      @event = Event.where(id: params[:id]).first()
    end
    
    respond_to do |format|
      format.json { render :json => @event.to_json }
    end
  end

  def calendar_data

    Event.update_from_api

    @month = get_month(params)
    data = {}

    date_start = @month.beginning_of_month.to_date
    date_end = @month.end_of_month.to_date

    event_count_by_day = Event.from_to(date_start, date_end).count(group: 'DATE(date_start)')
    event_count_by_day.default = 0

    random_data = DayProgress.fill_random_data(event_count_by_day.keys)

    1.upto(@month.end_of_month.day) do |i|
      day = @month.beginning_of_month.to_date + (i-1).day
      data[i] = [random_data[day], event_count_by_day[day]]
    end

    respond_to do |format|
      format.json { render :json => data.to_json }
    end

  end

  private
  def get_month(params)
    if params[:year] && params[:month]
      return Time.new(params[:year].to_i, params[:month].to_i, 1).beginning_of_month.to_date
    end
    return Time.now.beginning_of_month.to_date
  end

end
