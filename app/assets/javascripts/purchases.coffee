# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

setTableRowsClickablePrizes = undefined
disableConfirm = undefined
enableConfirm = undefined

disableConfirm = -> 
  $('#purchase_confirm_button').attr('class', 'btn btn-danger btn-xxl')
  $('#purchase_confirm_button').attr("disabled", true)
  return

enableConfirm = -> 
  $('#purchase_confirm_button').attr('class', 'btn btn-success btn-xxl')
  $('#purchase_confirm_button').attr("disabled", false)
  return

$(document).ready ->
  setTableRowsClickablePrizes()
  setQuantityListener()
  return

setQuantityListener = ->
  quantity = document.getElementById('prize_quantity')
  cost = document.getElementById('prize_cost')
  balance = parseInt(document.getElementById('balance-holder').innerHTML)
  quantity.onkeyup = (q) ->
    if (quantity.value * cost.value.replace('$','')) > balance
      disableConfirm()
    else
      enableConfirm()
  return

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
        id = undefined
        subid = undefined
        name = undefined
        cost = undefined
        size = undefined
        color = undefined
        f7 = undefined
        if @parentNode.nodeName == 'THEAD'
          return
        cells = @cells
        id = document.getElementById('prize_id')
        subid = document.getElementById('prize_subcat_id')
        name = document.getElementById('prize_name')
        brand = document.getElementById('prize_brand')
        cost = document.getElementById('prize_cost')
        size = document.getElementById('prize_size')
        color = document.getElementById('prize_color')
        id.value = cells[1].innerHTML
        subid.value = cells[0].innerHTML
        name.value = cells[2].innerHTML
        brand.value = cells[3].innerHTML
        cost.value = cells[5].innerHTML
        size.value = cells[6].innerHTML
        color.value = cells[7].innerHTML

        costVal = cells[5].innerHTML.replace('$','')
        balanceVal = parseInt(balance.innerHTML)

        if costVal > balanceVal
          disableConfirm()
        else
          enableConfirm()

        document.getElementById('prize_quantity').value = 1
        if cells[7].innerText is 'Yes'
          $('#order_notice').css('display','inherit')
          $('#purchase_prize_types').css('display','none')
        else
          $('#order_notice').css('display','none')
          $('#purchase_prize_types').css('display','inherit')
        return

      i++
  return
