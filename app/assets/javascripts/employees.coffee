# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#search_employee_button').on "click", ->
    $.get $('#employee_search').attr('action'), $('#employee_search').serialize(), null, 'script'
    false
  return
