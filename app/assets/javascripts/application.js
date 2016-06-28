// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require underscore
//= require gmaps/google
//= require bootstrap-datepicker
//= require fullcalendar
//= require bootstrap-timepicker
//= require clients
//= require properties
//= require jobs
//= require ckeditor/init
//= require jquery.raty.min
//= require LiveValidation
//= require jquery.Jcrop.min
//= require cropsetup
//= require jquery.dataTables.min
//= require calender
//= require c3
//= require charge
//= require chemicals
//= require custom
//= require d3
//= require full_calender
//= require home
//= require invoice
//= require jquery.signaturepad.min
//= require json2.min
//= require markerclusterer
//= require quotes
//= require repeats
//= require stripe
//= require jquery.liveaddress
//= require timesheets
//= require underscore
//= require jquery-ui
//= require events
//= require demo
//= require bootstrap-datetimepicker.min
//= require jquery.titlealert
//= require twilio.min
//= require twilio_device
//= require bootstrap-multiselect
//= require bootstrap-multiselect-collapsible-groups
//= require bootstrap-colorpicker
//= require private_pub
//= require users
//= require chat
function table_sort_function(){
  $('#report_jobs').dataTable();
  $(".dataTables_filter").hide();
}

function table_column_select(){
var i=0;
var column_count = $('table').children('thead').children('tr').children('th').length;
$("input:checkbox").click(function(){
    var column = "table ." + $(this).attr("name");
    if(!this.checked){ i++;}else if(this.checked){i--;}
    if(i==0)
      {
        $("#column_selector").removeClass("hidden_column")
        $("#column_selector_count").html(" ")
      }
    else
      {
        $("#column_selector_count").html((column_count-i)+'/'+column_count)
        $("#column_selector").addClass("hidden_column")
      }
    $(column).toggle();
});
}

$(document).ready(function(){
$(function($) {
  $("tr[data-link]").click(function() {
    window.location = this.dataset.link
  });
})
 

})


function unscheduledEvent(event,start,end,event_type){
   jQuery.ajax({
        data: 'id=' + event._id + '&title=' + event.title + '&start_date=' + start +'&end_date='+ end+'&event_type='+ event_type ,
        dataType: 'script',
        type: 'post',
        url: "/basic_tasks/move"
    });
}

function moveEvent(event, dayDelta,allDay){
  start = new Date(event.start._i)
  new_start =new Date(start.setDate(start.getDate() + (dayDelta._days)))
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&start_date=' + new_start +'&type='+ event.event_type ,
        dataType: 'script',
        type: 'post',
        url: "/events/move"
    });
}


  $(document).on('change', '.start-timesheet, .end-timesheet', function(){
    var dur = $(this).parent().parent().attr("class")
    var start = $('.'+dur )[0].children[0].children[1].value
    var end = $('.'+dur )[0].children[1].children[1].value
    var duration = "0:0"
    var ssplit = start.split(':')
    var esplit = end.split(':')
    var fstart = parseFloat(ssplit.join('.'))
    var fend =  parseFloat(esplit.join('.'))
    if (ssplit[0] == esplit[0]){
      if (ssplit[1] == esplit[1]){
        duration ="0:0"
      }
      else if (ssplit[1] > esplit[1])
      {
        duration = (23+":"+(60 + (esplit[1]- ssplit[1])))
      }
      else if (ssplit[1] < esplit[1]){
        duration = (00+":"+(esplit[1]-ssplit[1]))
      }
    }
    else if (ssplit[0] > esplit[0])
      {  
        if (ssplit[1] == esplit[1]){
          duration = ((24+(esplit[0]-ssplit[0]))+":"+00)
        }
        else if (ssplit[1] > esplit[1]){
           duration = ((23+(esplit[0]-ssplit[0]))+":"+(60-(ssplit[1] - esplit[1])))
        }
        else if (ssplit[1] < esplit[1]){
          duration = ((24+(esplit[0]-ssplit[0]))+":"+(esplit[1]-ssplit[1]))
        }
      }
    else if (ssplit[0] < esplit[0])

      {
        if (ssplit[1] > esplit[1]){
          duration =(Math.abs( 1-(esplit[0]-ssplit[0]))+":"+(60+(esplit[1]-ssplit[1])))
        }
        else if (ssplit[1] == esplit[1]){
          duration = (esplit[0]-ssplit[0])
        }
        else if (ssplit[1] < esplit[1]){
          duration =( (esplit[0]-ssplit[0]) +":"+(esplit[1]-ssplit[1]))
        }
      }  

    $('.'+dur )[0].children[2].children[1].value = duration   
  })
jQuery(document).ready(function(){
  var callAjax = function(){
    jQuery.ajax({
      method:'get',
      url:'/conversations/notify'
    });
  }
  setInterval(callAjax,30000);
});