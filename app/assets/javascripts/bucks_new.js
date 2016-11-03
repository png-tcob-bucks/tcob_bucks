window.onload = function() {
  var j, k, rows;
  j = void 0;
  k = void 0;
  k = document.getElementById('table-bucks-employee-list');
  if (k !== null) {
    rows = k.rows;
    j = 0;
    while (j < rows.length) {
      rows[j].onclick = function(event) {
        var cells, s1, s2, s3;
        cells = void 0;
        s1 = void 0;
        s2 = void 0;
        s3 = void 0;
        if (this.parentNode.nodeName === 'THEAD') {
          return;
        }
        cells = this.cells;
        s1 = document.getElementById('buck_employee_id');
        s2 = document.getElementById('employee_first_name');
        s3 = document.getElementById('employee_last_name');
        s1.value = cells[0].innerHTML;
        s2.value = cells[1].innerHTML;
        s3.value = cells[2].innerHTML;
      };
      j++;
    }
  }
}

// Code for updating value based on reason for buck rewarded
function updateBuckValue(earned_for) {
	var buck_value = document.getElementById('buck_value');
    	switch(earned_for.value) {
           case "A+ Service":
             buck_value.value = 20;
             hide_reason_field();
           break;
           case "Attendance":
             buck_value.value = 3;
             hide_reason_field();
           break;
           case "Community Involvement":
             buck_value.value = 3;
             hide_reason_field();
           break;
           case "Customer Service":
             buck_value.value = 5;
             display_reason_field();
           break;
           case "Shift Coverage":
             buck_value.value = 2;
             hide_reason_field();
           break;
           case "Other":
              buck_value.value = 0;
              display_reason_field();
           break;
           default:
             buck_value.value = 0;
             hide_reason_field();
           break;
   }
}

function display_reason_field() {
  var f = document.getElementById('reason_long_holder');
  f.style.display = 'table-cell';
}

function hide_reason_field() {
  var f = document.getElementById('reason_long_holder');
  f.style.display = 'none';
}

function toggle_reasons() {
   var o = document.getElementById('reason_long_options');
   var t = document.getElementById('reason_long');
   var r = document.getElementById('toggle_reasons');
   if(o.style.display == 'block') {
      t.style.display = 'block';
      o.style.display = 'none';
      r.innerHTML = "+ Common Reasons"
    }
   else {
      t.style.display = 'none';
      o.style.display = 'block';
      r.innerHTML = "- Common Reasons"
    }
    updateLength();
}

function updateReasonValue(obj) {
  var text_area = document.getElementById('reason_long');
  var value = obj.innerHTML;
  text_area.value = value;
  toggle_reasons();
}

function textLength(value){
   var maxLength = 255;
   if(value.length > maxLength) return false;
   return true;
}

function updateLength() {
  var counter = document.getElementById('text_length');
  var text_area = document.getElementById('reason_long');
  counter.innerHTML = text_area.value.length + "/250 characters max"
}