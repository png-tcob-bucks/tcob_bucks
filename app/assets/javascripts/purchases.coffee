# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateConfirmButton = (cost, balance) ->
  if cost > balance
    $('#purchase_confirm_button').attr 'class', 'large-stop'
  else
    $('#purchase_confirm_button').attr 'class', 'large-go'
    $('#purchase_confirm_button').attr("disabled", false)
  return

$(document).ready ->
  setTableRowsClickablePrizes()
  return

setTableRowsClickablePrizes = undefined

setTableRowsClickablePrizes = ->
  i = undefined
  t = undefined
  t = document.getElementById('table-prizes-small')
  balance = document.getElementById('balance-holder')
  if t != null
    rows = t.rows
    i = 0
    while i < rows.length

      rows[i].onclick = (event) ->
        cells = undefined
        f1 = undefined
        f2 = undefined
        f3 = undefined
        f4 = undefined
        f5 = undefined
        f6 = undefined
        f7 = undefined
        if @parentNode.nodeName == 'THEAD'
          return
        cells = @cells
        f1 = document.getElementById('prize_id')
        f2 = document.getElementById('prize_subcat_id')
        f3 = document.getElementById('prize_name')
        f4 = document.getElementById('prize_cost')
        f5 = document.getElementById('prize_size')
        f6 = document.getElementById('prize_color')
        f1.value = cells[1].innerHTML
        f2.value = cells[0].innerHTML
        f3.value = cells[2].innerHTML
        f4.value = cells[4].innerHTML
        f5.value = cells[5].innerHTML
        f6.value = cells[6].innerHTML
        
        updateConfirmButton(cells[4].innerHTML, parseInt(balance.innerHTML))

        if cells[7].innerText is 'Yes'
          $('#order_notice').css('display','inherit')
          $('#purchase_prize_types').css('display','none')
        else
          $('#order_notice').css('display','none')
          $('#purchase_prize_types').css('display','inherit')
        return

      i++
  return
