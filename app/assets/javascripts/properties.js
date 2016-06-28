

function propertyShowView(){
	
	$("tr[data-link]").click(function() {
	window.location = this.dataset.link
	});
}


function searchPropertyClientModel(inputVal){
  var data = inputVal
  $.ajax({
          type: "POST",
          url: "/search_client_property",
          data: {q: data}
         }); 

  }



function searchPropertyClient(inputVal){
    
	  var table = $('#tblData_properties');
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
	      if(found == true)$(row).show();else $(row).hide();
	    }
	  });
	}

function Validation(){
	$(document).ready(function(){
	var property_street = new LiveValidation('property_street');
	property_street.add( Validate.Presence );

	// var property_street2 = new LiveValidation('property_street2');
	// property_street2.add( Validate.Presence );

	var property_city = new LiveValidation('property_city');
	property_city.add( Validate.Presence );

	var property_state = new LiveValidation('property_state');
	property_state.add( Validate.Presence );

	var property_zipcode = new LiveValidation('property_zipcode');
	property_zipcode.add( Validate.Presence );
	})

}

function workProperty(){ 
$('div[id^=tab]').hide();
$('#tab1').show();
$('.tab_selector a').click(function () {
   var tab_id = $(this).attr('href'); 
   $('div[id^=tab]').hide();
   $(tab_id).show(); 
   return false;
});





 $(".property_note").focus(function() {
    $("#attachment_field").css("display","block");
    $(".attach_files").css("display","none");
    $("#property_note_submit").css("display","block");
    $("#property_attach").css("display","block");
  })
  $(".attach_files").click(function(){
    $("#attachment_field").css("display","block");
    $(".attach_files").css("display","none");
    $("#property_note_submit").css("display","block");
    $("#property_attach").css("display","block");
  })
  $("#property_attach").click(function(){
    $("#attachment_field").css("display","none");
    $(".attach_files").css("display","block");
    $("#property_note_submit").css("display","none");
    $("#property_attach").css("display","none");
  })
}


 function basicPropertyTask(id,data,user_id,property_id){
    $.ajax({
      type: "POST",
      url: "/basic_task_complete",
      data: {is_complete: data, basic_id: id, complete_by: user_id,property_id: property_id}
    });
 }