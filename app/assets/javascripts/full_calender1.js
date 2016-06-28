$(document).ready(function(e) {
  var monthNames = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ];
  var d = new Date();
  $("#current_date").html(monthNames[d.getMonth()]+" "+d.getFullYear());
  $('#btnNext').click(function(e) {
    $('#calendar').fullCalendar('next'); 
    $("#current_date").html( $("#calendar").find('span.fc-header-title h2').text());  
    e.preventDefault(); 
  });     
  $('#btnPrev').click(function(e) {
    $('#calendar').fullCalendar('prev');        
    $("#current_date").html( $("#calendar").find('span.fc-header-title h2').text());
    e.preventDefault(); 
  });

  $('.fc-button-month').on('click',function(){$('#calender_month').click();});
  $('.fc-button-agendaWeek').on('click',function(){$('#calender_week').click();});
  $('.fc-button-agendaDay').on('click',function(){$('#calender_grid').click();});
});

function draw_calender(calender_id,event_json){
  var months = [ "January", "February", "March", "April", "May", "June", 
               "July", "August", "September", "October", "November", "December" ]
  var align = ""
  $('#'+calender_id).fullCalendar({
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultDate: 'currentDate',
    selectable: true,
    selectHelper: true,
    select: function(start, end) {
      $(".innerFrame.click_ignore .header .title").text("Add to"+" "+months[start.getMonth()]+" "+start.getDate());
      $('#calendar').fullCalendar('unselect');
    },
    eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
      moveEvent(event, dayDelta, minuteDelta, allDay); 
    },
    dayClick: function (date, allDay, event, view) {
      if((event.pageX)/100>11){align='left'}else{align='right'}
      $("#current_date").html( $("#calendar").find('span.fc-header-title h2').text());
      $(this).children().popover({
        placement: align,
        trigger : 'click',
        animation : 'true',
        content: '<div class="innerFrame click_ignore"><div class="header"><div class="title">Add to August 12</div></div><div class="content"><div class="dropdown_menu icon_drop"><ul class="new_list" id="calender_popover"><li><i class="fa fa-check-square-o"></i><a href="/basic_tasks/to_dos?todo[start_at]='+date+'&todo[end_at]='+date+'&todo[all_day]=true&todo[plugin_type]=basic_task" id="new_to_do" class="spin_on_click has_icon click_ignore" data-remote="true">New Basic Task</a></li><li><i class="fa fa-calendar"></i><a href="/events/to_dos?todo[start_at]='+date+'&todo[end_at]='+date+'&todo[all_day]=true&todo[plugin_type]=event" id="new_calendar_event" class="spin_on_click has_icon click_ignore" data-remote="true">New Event</a></li><li><i class="fa fa-legal"></i><a href="/events/new_job_event?todo[start_at]='+date+'" id="new_job" class="spin_on_click has_icon click_ignore" data-remote="true">New Job</a></li><li class="separator"></li><li><i class="fa fa-users"></i><a href="#" class="has_icon group" onclick=$("#calender_grid").click(); return false;>Show Grid</a></li></ul></div></div></div>',
        html: true,
        container: 'body'
      });
      $('.popover.in').remove();
      $(this).children().popover('show');
      $('.popover').css('left', event.pageX+'px');
      $('.popover').css('top', event.pageY+'px');
      $('.popover').addClass('basic_task');
      $('.arrow').attr('style', 'top: 6%');
    },
    editable: true,
    eventLimit: true, // allow "more" link when too many events
    events: event_json,
    eventColor: 'white',
    eventRender: function (event, element) {
      $("#current_date").html( $("#calendar").find('span.fc-header-title h2').text());
      element.popover({
        placement: 'right',
        trigger : 'click',
        animation : 'true',
        content: event.message,
        html: true,
        container: 'body'
      });
      $('body').on('click', function (e) {
        if (!element.is(e.target) && element.has(e.target).length === 0 && $('.popover').has(e.target).length === 0)element.popover('hide');
          $('.popover').popover('hide');
      });
      $(element).css('height','20px');
      $(element).css('text-decoration', event.task_css);
      $(element).css('border-color', event.ecolor);
    },
    eventClick: function(){$('.popover').popover('hide');}
  });
}
