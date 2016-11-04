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