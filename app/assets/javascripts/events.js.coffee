
$(document).ready ->

  $(document).on("click", "a.prev_next_month", () ->
    $('#search_query_date').val("")
    load_calendar($(this).attr('href'));
    return false;
  )

  $(document).on("click", "#search_query_date", () ->
    if is_calendar_visible()
      return true
    load_calendar()
    return false
  )

  $(document).on("click", "table.calendar td", () ->
    click_calendar_day_handler($(this))
    return false
  )


click_calendar_day_handler = (element) ->
  this_element = $('.content_holder', element)

  if this_element.hasClass('selected')
    return true

  selected_elements_num = $('#calendar-holder .content_holder.selected').length

  first_element = $('#calendar-holder .content_holder.selected.first')
  last_element = $('#calendar-holder .content_holder.selected.last')
  this_element = $('.content_holder', element)

  first_date = first_element.attr('data-date')
  last_date = last_element.attr('data-date')
  this_date = this_element.attr('data-date')

  if selected_elements_num == 0
    # no markers
    this_element.addClass('selected')
    this_element.addClass('first')
  else if selected_elements_num == 1
    # First marker is present
    if this_date > first_date
      this_element.addClass('selected')
      this_element.addClass('last')
    else
      this_element.addClass('selected')
      this_element.addClass('first')
      first_element.removeClass('first')
      first_element.addClass('last')
  else
    # Both markers are present
    if (this_date < first_date)
      first_element.removeClass('selected')
      first_element.removeClass('first')
      this_element.addClass('selected')
      this_element.addClass('first')
    else
      last_element.removeClass('selected')
      last_element.removeClass('last')
      this_element.addClass('selected')
      this_element.addClass('last')

  first_element = $('#calendar-holder .content_holder.selected.first')
  last_element = $('#calendar-holder .content_holder.selected.last')
  first_date = first_element.attr('data-date')
  last_date = last_element.attr('data-date')

  if last_date == undefined
    last_date = ''

  $('#search_query_date').val("#{first_date} - #{last_date}")
  return true


get_month_data = (month) ->
  url = $('span.curr_month').attr('data-calendar-data-url')
  $.getJSON(url, (data) ->
    n = 0;
    content_elements = $('#calendar-holder .content')
    content_elements.html('')
    $.each(data, (key, val) ->
      if val[1] == 0
        $(content_elements[n]).html(tmpl("tmpl-no-events", val))
      else
        $(content_elements[n]).html(tmpl("tmpl-events", val))

      n += 1;
    )
    $("#calendar-holder .progress").knob({readOnly: true});
  )

is_calendar_visible = () ->
  $('#calendar-holder').html().replace(/^\s+|\s+$/g, '').length > 0

load_calendar = (url_year_month) ->

  if url_year_month
    url = url_year_month
  else
    url = window.calendar_events

  console.log(url)
  $.ajax
    url: url
    success: (data)->
      $("#calendar-holder").html(data)
      get_month_data('date?')
    error: (data, text_status)->
      $("#calendar-holder").html(text_status)

jQuery.fn.exists = () -> return this.length > 0;