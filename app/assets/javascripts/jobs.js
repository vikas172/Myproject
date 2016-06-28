// $(function($) {
// document.getElementById('job_scheduled').onchange = function() {
//     document.getElementById('one_off_check_time').style.display = this.checked ? 'block' : 'none';
// };
// })


function check_assigned(){

}

$(document).on("click", ".clickMeShow",function(){
  $(".employee_check").each(function(){ 
      var employee_name =  this.parentElement.textContent.replace(/\s/g, "");
      if($("#job_assign_user").text().indexOf(employee_name) > -1 ){
        $(this).prop("checked",true);
      }
  })
})

function myJobfunc(id, user_name){
  var value = $('#'+id).val();
  if ($('#job_assign_user').text().indexOf(user_name)  == -1 ){
    if($('#'+id).prop('checked')){
      $('#job_assign_user').append('<div id="crew_'+value+'"><span id='+id+'>- '+user_name+'</span><input id="member_selected_'+value+'" name="job[crew][]" type="hidden" value='+value+'><br/></div>')
    }else{
      $('#crew_'+value+'').remove();
    }
  }
  if($('#'+id).prop('checked')){
  }else{
    $('#crew_'+value+'').remove();
  }
}

$(function($) {
  $("tr[data-link]").click(function() {
    window.location = this.dataset.link
  });
})

function checkBoxCheked(){
  $("#job_scheduled").prop('checked', true);
  $("#job_job_type_one_off").prop('checked', true);
  $( "#timepicker" ).timepicker();
  $( "#timepicker1" ).timepicker();
  $( "#datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });
  $( "#datepicker1" ).datepicker({ dateFormat: 'yy-mm-dd' });
}
$(document).ready(function(){
  $('#job_scheduled').on("change", function() {
    document.getElementById('one_off_check_time').style.display = this.checked ? 'block' : 'none';
  });
})


  $("[data-toggle=popover]") .popover({html:true } )
  $('body').on('click', function (e) {
      $('[data-toggle=popover]').each(function () {
          // hide any open popovers when the anywhere else in the body is clicked
          if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
              $(this).popover('hide');
          }
      });
  });
function select_period(){
  $("#job_invoice_period,.job_start_date").change(function(){
    if ($('#job_invoice_period').val()=='Monthly on the last day of month') 
      {
        $("#begin_end_date").html("");
        var d=$( "#datepicker" ).datepicker('getDate');
        var lastOfMonth = new Date(d.getFullYear(),d.getMonth()+1, 0);
        var month_val= d.getMonth()+1
        document.getElementById('month_last_date').innerHTML='first invoice on '+lastOfMonth.getDate()+'/'+month_val+'/'+lastOfMonth.getFullYear() ;
      }
    else if($('#job_invoice_period').val()=='Monthly')
      {
        $("#month_last_date" ).html("");
        var date=$( "#datepicker" ).datepicker('getDate');
        var second_date = new Date(date);        
        curr_date = second_date.getDate();
        curr_month= second_date.getMonth()+2;
        curr_year = second_date.getFullYear();
        var d = curr_year +'-'+  curr_month + '-' + curr_date 
        $( "#begin_end_date" ).html('<div class="field"><ul style="margin:0px 0px 10px 0px;" ><li>First invoice on &nbsp;&nbsp;&nbsp;&nbsp;<input id="first_invoice_on_start_date" type="radio" value='+$("#datepicker").val()+' name="first_invoice_on">'+$("#datepicker").val()+'</li><li style="margin-left:40px;"><input id="first_invoice_on_start_date" type="radio" name="first_invoice_on" value="'+d+'"/>'+d+'</li></ul></div>');
      }
    else if($('#job_invoice_period').val()=="As needed - we won't prompt you" || $('#job_invoice_period').val()=="After each visit")
      {
        $("#month_last_date" ).html("");
        $("#begin_end_date").html("");
      }
    else
      {
        $( "#month_last_date" ).html("");
        $("#begin_end_date").html("");
      }
  });

  $(".visits").change(function(){ 
    if ($('.visits').val()=="As needed - we won't prompt you") {
      $(".vis").hide()
    } else{
      $(".vis").show()
    };
  });



   $("#job_number_of_invoice").change(function(){
    var invoice_type = $("#job_invoice_type").val();
    var total = $('#job_number_of_invoice').val();
    if (invoice_type == "days")
      {
         if (total < 731)
        {
          $(".recurring_starton").html(Math.ceil(total/30));
        }
        else
        {
          alert("Days not more then 730... ");
          var total = $('#job_number_of_invoice').val("");
        }
      }
    else if (invoice_type == "weeks")
      {
        if (total < 105)
        {
        $(".recurring_starton").html(Math.ceil(total/4));
        }
        else
        {
          alert("weeks not more then 104...");
          var total = $('#job_number_of_invoice').val("");
        }
      }  
    else if (invoice_type == "months")
      {
        if (total < 25)
        {
          $(".recurring_starton").html(total)
        }
        else
        {
          alert("Months not more then 24...");
          var total = $('#job_number_of_invoice').val("");
        }
      }
    else
      {    
       $(".recurring_starton").html(total*12);
      }  
  })

  $("#job_invoice_type").change(function(){
    var invoice_type = $("#job_invoice_type").val();
    var total = $('#job_number_of_invoice').val();
    if (invoice_type == "days")
      {
         if (total < 731)
        {
          $(".recurring_starton").html(Math.ceil(total/30));
        }
        else
        {
          alert("Days not more then 730... ");
          var total = $('#job_number_of_invoice').val("");
        }
      }
    else if (invoice_type == "weeks")
      {
        if (total < 105)
        {
        $(".recurring_starton").html(Math.ceil(total/4));

        }
        else
        {
          alert("weeks not more then 104...");
          var total = $('#job_number_of_invoice').val("");
        }
      }  
    else if (invoice_type == "months")
      {
        if (total < 25)
        {
          $(".recurring_starton").html(total)
        }
        else
        {
          alert("Months not more then 24...");
          var total = $('#job_number_of_invoice').val("");
        }
      }
    else
      {    
       $(".recurring_starton").html(total*12);
      }  
  })


$(".job_start_date").change(function(){
  var start_date = $(this).val();
  objDate = new Date(start_date);
  var days= ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  var day_1 = days[objDate.getDay()]
  var date_1 = objDate.getDate()
  $( "#work_order_dispatch_rrule" ).html( "<option selected='selected' value='Weekly on "+day_1+"s' id='weekly-visit'> Weekly on "+day_1+"s</option><option value='Monthly on the "+date_1+" day of the month' id='monthly-visit'>Monthly on the "+date_1+" day of the month</option><option value='custom' data-toggle='modal' data-target='#repeatModal'>Custom schedule...</option>" );
}) 



 $("#job_invoice_type,#job_number_of_invoice,.job_start_date").change(function(){  
    var number = $("#job_number_of_invoice").val();
    var type = $("#job_invoice_type").val();
    var st_date = $(".job_start_date").val();
    $.ajax({
        type: "POST",
        url: "/get_end_date",
        data: {number: number, type:type , st_date:st_date}
        }); 

  })
}


function searchJobIndex(value){
  $(".job_type_filter").attr('disabled', 'disabled');
  $(".filter_job_number").attr('disabled', 'disabled');

  var data =value
  if (data==""){
    $('.job_type_filter').removeAttr('disabled');
    $(".filter_job_number").removeAttr('disabled');
  }
  data=value
  if (!isNaN(data)){
    searchTable('#'+data);
  }
  else
  {
    searchTable(data);
  }
 
  function searchTable(inputVal){
    var inputVal=inputVal.trim()
    var table = $('#tblData');
    table.find('tr').each(function(index, row)
    {
      var allCells = $(row).find('td');
      if(allCells.length > 0)
      {
        var found = false;
        allCells.each(function(index, td)
        {
          var regExp = new RegExp(inputVal, 'i');
          if(regExp.test($(td).text()))
          {
            found = true;
            return false;
          }
        });
        if(found == true){
          $(row).show();
          $('#output').html('') 
          }
        else{
          $(row).hide(); 
          $(row).find('td').each(function(index, td)
          {
            if ($('.propert').is(':visible')) {
             $('#output').html('') 
            } else{
              $('#output').html('<b>No matching items</b>');
            };

          });
        };
      }
    });
  }
}

function sortJobType(value){
 var data = value
  $.ajax({
    type: "POST",
    url: "/job_type_sort",
    data: {job_type: data}
   });
}

function sortByJobFirstLast(value){
   var data = value
    $.ajax({
    type: "POST",
    url: "/job_sort",
    data: {sort_by: data}
   });
}

function searchClientJobModel(value){
  var data = value

  $.ajax({
    type: "POST",
    url: "/search_job_client",
    data: {q: data}
  }); 
}

function upComingLate(value){
  var data = value
  $.ajax({
    type: "POST",
    url: "/search_coming_job",
    data: {job_status: data}
  }); 
}

function AddjobWork() {
  $('.start_date_visit').datepicker({ dateFormat: 'yy-mm-dd' })
  $('.end_date_visit').datepicker({ dateFormat: 'yy-mm-dd' })
  $('#start_time').timepicker();
  $('#end_time').timepicker();

  var scntDiv = $('#add_more_work');
  var i = $('#add_more_work p').size();
  
  $("#addScnt").on("click",function(){
    var j=i+1;
    $('<p><label for="p_scnts"><input type="text" id="p_name_'+j+'" size="20" name="name[]" value="" placeholder="name..." style="margin-left: 5%; width: 14%;" required="required" class="work_name"/><textarea style="height: 47px; margin-left: 4.2%; width: 39.3%;" placeholder="description..." name="description[]" id="p_description_'+j+'" class="work_description"></textarea><input type="text" id="p_quantity_'+j+'" size="20" name="quantity[]" value="1" style="width: 4%; margin-left: 13%;" onchange="AddQuantity(this.id)"/>$<input type="text" id="p_unit_cost_'+j+'" size="20" name="unit_cost[]" placeholder="0.00" style="width: 4%; margin-left: 1%;" onchange="AddUnitCost(this.id)"/>$<input type="text" id="p_total_'+j+'" size="20" name="total[]" placeholder="0.00"style="margin-left: 1%; width: 4%; " class="p_total" readonly="readonly"/></label> <b style="margin-top: -8.8%; width: 1%;" href="" class="remScnt btn btn">-</b></p>').appendTo(scntDiv);
      i++;
  });

  $("#add_more_work").on("click",".remScnt", function(){
      $(this).parent().remove();
      i--;
  });
}

function AddjobQuantity(j,i) {
  var a =j
  var c=j.lastIndexOf("_")+1
  var d=j.substr(c,4)
  var b=$("#p_unit_cost_"+i).val()
  if ((!isNaN(b)) && (b != "") && (!isNaN(a)))
  {
    $('#p_total_'+i).val((a*b).toFixed(2));
  }
  else
  {
    $('#p_total_'+i).val(0.00);
  }
}

function AddJobUnitCost(j,i) {
  var b =j
  var c=j.lastIndexOf("_")+1
  var d=j.substr(c,4)
  var a=$("#p_quantity_"+i).val()
  if (!isNaN(b)&& (!isNaN(a))){
    $('#p_total_'+i).val((a*b).toFixed(2));
  }
  else
  {
    $('#p_total_'+i).val(0.00) 
  }
}

function Show_total()
{
  $(document).ready(function(){
  var val=0
  var a=0
  $(".show_total").each(function(){
    a=parseFloat($(this).html());
    if (!isNaN(a)) {
    val += a;
  }
 
  })
   $('#subtotal').html('<b>Subtotal: </b>'+val.toFixed(2));

  })
}

function CompleteJob(id, data, name ){
  $.ajax({
    type: "POST",
    url: "/job_completed",
    data: {job_type: data, visit_schedule_id: id, completed_by: name},
    success: function(data) {
      var all_job = $('#to_do_content').hasClass('all_job');
      var overdue_job = $('#to_do_content').hasClass('overdue_job');
    }
  });
}

//new job js for recurring and one off
function job_scheduled_date(){
  var d = new Date();
  var twoDigitMonth=((d.getMonth()+1)>=10)? (d.getMonth()+1) : '0' + (d.getMonth()+1);  
  var twoDigitDate=((d.getDate())>=10)? (d.getDate()) : '0' + (d.getDate());
  var d= d.getFullYear() + '-' + twoDigitMonth + '-' + twoDigitDate;

  if ($('#job_scheduled').prop('checked')){
    $('.job_start_date').removeAttr("disabled", true);
    $('.job_start_date').val(d)
    $('.job_end_date').attr('placeholder','Optional');
    $('.job_end_date').removeAttr("disabled", true);
    $('#visit_check').html('This job will show up in schedules on the start date')
  }else{
    $('.job_start_date').attr("disabled", true);
    $('.job_start_date').val('')
    $('.job_end_date').attr("disabled", true);
    $('.job_end_date').val('');
    $('.job_end_date').removeAttr('placeholder','');
    $('#visit_check').html('<input checked="checked" id="active_dispatch_check_box" name="job[visits]" onclick="unscheduled_visit_check_job()" type="checkbox" value="true">Add an Unscheduled Visit to the Calendar')
  }
}

function unscheduled_visit_check_job(){
  // schedule with crew check box
  if ($('#active_dispatch_check_box').prop('checked')){
    $('#unscheduled_visit_calender_job').css("display", "block");
  }else{
    $('#unscheduled_visit_calender_job').css("display", "none");
  }
}

function when_multiday_select(){
  var start_date = $('.job_start_date').val()
  var end_date = $('.job_end_date').val()
  if (start_date < end_date){
    $('#visit_check').html('<span class="when_multiday" style="display: inline;"><select class="recurring_select" id="work_order_dispatch_rrule" name = "job[visits]"><option value="null">As needed - we won\'t prompt you</option><option selected="selected" value="daily">Daily</option><option value="weekly">Weekly</option><option value="monthly">Monthly</option></select><span class = "description"> - until job is completed</span></span>')
  }
  else
  {
    $('#visit_check').html("<b>This job will show up in schedules on the start date</b>");
  }
  $('#work_order_dispatch_rrule').on("change", function(){
    $(function() {
      if ($('#work_order_dispatch_rrule').val() == "null"){
        $('#optional_fields').hide();
      }else{
        $('#optional_fields').show();
      }
    })
  })
  $('#work_order_dispatch_rrule').on("change", function(){
    if ($('#work_order_dispatch_rrule').val() == "custom"){
      $(function() {
        $('#repeatModal').modal('show')
      });
    }
  })
  $('#job_invoice_period').on("change", function(){
    if ($('#job_invoice_period').val() == "custom"){
      $(function() {
        $('#repeatModal').modal('show')
      });
    }
  })
  $("#clickMeShow").on("click", function(){
   $('#job_time_show').css("display", "none");
    $('#times').css("display", "block");
  })
  $('#clickMeHide').on("click", function(){
    $('#job_time_show').css("display", "block");
    $('#times').css("display", "none");
  })
}

