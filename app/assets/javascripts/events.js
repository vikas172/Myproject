$(document).on("click", ".popoverThis",function(){
  $(".employee_check").each(function(){ 
      var employee_name =  this.parentElement.textContent.replace(/\s/g, "");
      if($("#job_assign_user").text().indexOf(employee_name) > -1 ){
        $(this).prop("checked",true);
      }
  })
})
$(document).on("click", ".clickMeShow",function(){
  $(".employee_check").each(function(){ 
      var employee_name =  this.parentElement.textContent.replace(/\s/g, "");
      if($("#task_assign_user").text().indexOf(employee_name) > -1 ){
        $(this).prop("checked",true);
      }
  })
})
function myfunc(id, user_name){
	var value = $('#'+id).val();
  if($('#'+id).prop('checked')){
    $('#task_assign_user').append('<div id="assigned_to_'+value+'"><span>- '+user_name+'</span><input id="member_selected" name="basic_task[assigned_to][]" type="hidden" value='+value+'><br/></div>')
  }else{
  	$('#assigned_to_'+value+'').remove();
  }
}

function searchClientEventModel(value){
  var data = value
  $.ajax({
    type: "POST",
    url: "/events/search_job_client",
    data: {q: data}
  }); 
}

function attachmentQuoteEmail(id,attach,attach_id){
  var value = $('#'+id).val();
  if($('#'+id).prop('checked')){
    $('#attach_select_user').append('<div id="attach_'+id+'"><span>- '+attach+'</span><input id="attach_selected" name="attachment[assigned_to][]" type="hidden" value='+attach_id+'><br/></div>')
  }
  else
  {
    $('#attach_'+id).remove();
  }
}