# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->

  $(document).on("click", "#search_query_date", () ->
    url = $(this).attr('data-calendar-url')
    $.ajax
      url: url
      success: (data)->
        $("#calendar-holder").html(data)
        $("#calendar-holder .progress").knob({readOnly: true});
      error: (data, text_status)->
        $("#calendar-holder").html(text_status)

    return false
  )

  $(document).on("click", "table.calendar td", () ->
    click_calendar_day_handler($(this))
#    url = $(this).attr('href')
#    $.ajax
#      url: url
#      success: (data)->
#        $("#calendar-holder").html(data)
#      error: (data, text_status)->
#        $("#calendar-holder").html(text_status)

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

jQuery.fn.exists = () -> return this.length > 0;