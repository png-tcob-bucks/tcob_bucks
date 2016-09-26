// Code for updating value based on reason for buck rewarded
function updateBuckValue(earned_for) {
	var buck_value = document.getElementById('buck_value');
    	switch(earned_for.value) {
           case "A+ Service":
           buck_value.value = 20;
           break;
           case "Attendance":
           buck_value.value = 3;
           break;
           case "Community Involvement":
           buck_value.value = 3;
           break;
           case "Customer Service":
           buck_value.value = 5;
           break;
           case "Shift Coverage":
           buck_value.value = 2;
           break;
           default:
           buck_value.value = 0;
           break;
   }
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