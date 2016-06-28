function calenderShow() {
  $('#calendar').fullCalendar({        
    header: {
      left: 'prev,next today',
      right: 'month,agendaWeek,agendaDay'
    },
    //events: './jobs/event-feed.php',
    events: '/events.json',
    editable: true,
    selectable: true,
    eventRender: function(event, element) {
      element.popover({
        html: true,
        placement: 'right',
        container: 'body',
        content: 'Start: ' + $.fullCalendar.formatDate(event.start, 'MM-dd-yyyy') + '<br />End: ' + event.end_date + '<br />Description: ' + event.description + '<br /><a href='+event.path+'>view Details</a>',
        title: event.title
      });
    },
    dayClick: function(date,start, end, allDay, jsEvent, view) {
      // $(this).parents.popover('hide');
      document.getElementById('abc').value=$.fullCalendar.formatDate(date, 'MMMM dd');
      $(this).children().popover({
        placement: 'right',
        title: function() {
          return $("#popover-head").html();
        },
        content: function() {
          return $("#popover-content").html();
        },
        html: true,
        container: 'body'
      });
      $('.popover.in').remove();   //<--- Remove the popover 
      $(this).children().popover('show');
      $('body').on('click', function (e) {
        $('.popover.in').remove();
      });
    }
  });

  $( "#timepicker" ).timepicker();
  $( "#timepicker1" ).timepicker();
  $(".datepicker").datepicker({ dateFormat: 'yy-mm-dd' })
  $('input[type="checkbox"]').click(function(){
    if($(this).find('input:checkbox').prop("checked", true)){
      $(".toggle-append").toggle();
    }
  });
} 
