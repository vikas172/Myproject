function pie_plot(graph_id, grah_data, date, any){
  // var f_date = date.map(function(p){ return '"' + p + '"'; }).join(',');
  var data = parseInt(grah_data)
  var chart = c3.generate({
      bindto: '#chart',
      data: {
        x: 'x',
        columns: [
          ['x', "2014-01-01", "2014-02-01", "2014-03-01", "2014-04-01", "2014-05-01", "2014-06-01", "2014-07-01", "2014-08-01", "2014-09-01", "2014-10-01", "2014-11-01", "2014-12-01"],
          [any, 0,0,0,0,0,0,0,0,0,0,0,data]
        ]
      },
      axis : {
          x : {
            type : 'timeseries',
            localtime: false,
            tick: {
                format: '%b %y'
            }
          }
      }
  });
}

function pie_plot1(graph_id, total, sent, won, date){
  var f_date = date.map(function(p){ return '"' + p + '"' }).join(',')
  var data = parseInt(total)
  var data1 = parseInt(sent)
  var data2 = parseInt(won)
  var chart = c3.generate({
    bindto: '#chart',
    data: {
      x: 'x',
      columns: [
        ['x', "2014-01-01", "2014-02-01", "2014-03-01", "2014-04-01", "2014-05-01", "2014-06-01", "2014-07-01", "2014-08-01", "2014-09-01", "2014-10-01", "2014-11-01", "2014-12-01"],
        ['draft', 0,0,0,0,0,0,0,0,0,0,0,data],
        ['sent', 0,0,0,0,0,0,0,0,0,0,0,data1],
        ['won', 0,0,0,0,0,0,0,0,0,0,0,data2]
      ]
    },
    axis : {
      x : {
        type : 'timeseries',
        localtime: false,
        tick: {
            format: '%b %y'
        }
      }
    }
  });
}

// function for open popover on click in
function popover_show(){
  $('.popover-markup>.trigger').popover({
    html: true,
    title: function () {
        return $(this).parent().find('.head').html();
    },
    placement: "bottom",
    content: function () {
        return $(this).parent().find('.content').html();
    }
  });
  $('[data-toggle="popover"]').popover();
  $('body').on('click', function (e) {
    if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0)
          $(this).popover('hide');
  });
}

// function for open popover on click in
function route_popover(){
  $('.route_popover > .trigger').popover({
    html: true,
    title: function () {
        return $(this).parent().find('.head').html();
    },
    placement: "right",
    content: function () {
        return $(this).parent().find('.content').html();
    }
  });
  $('[data-toggle="popover"]').popover();
}

// select selected range active 
function report_range_selecct(){
  var valueSelected  = $("#report_range").val();
  var textSelected = $( "#report_range option:selected" ).text()
  $( "#report_start_date" ).datepicker({ dateFormat: 'yy-mm-dd' })
  $( "#report_end_date" ).datepicker({ dateFormat: 'yy-mm-dd' })
  if (valueSelected == "custom")
  {
    $("#pickers").removeAttr("style")
    $('.label').html(textSelected)
  }else{
    $("#pickers").hide()
    $('.label').html(textSelected)
  }
}

// product and service popup js under setting
$(document).ready(function(){
  $("#product").click(function(){
    $("#work_item_item_type").val("product").trigger('change')
  })
  $("#service").click(function(){
    $("#work_item_item_type").val("service").trigger('change')
  })
})

// Custom filed add through js and Within home controller setting part

function customFieldSet() {

$("#custom_field_value_type").on("change",function() {

  var value=$(this).val();
  if (value=="boolean"){
  $('div#boolean_options').html('<p><label for="custom_field_info_options_default_bool_value">Default value</label><select name="custom_field[value_type][]" id="custom_field_info_options_default_bool_value"><option value="true">True</option><option value="false">False</option></select></p>');}

  if (value=="integer"){
    $('div#boolean_options').html('<p><label for="custom_field_info_options_default_int_value">Default value</label><input type="text" value="0" size="4" name="custom_field[value_type][]" id="custom_field_info_options_default_int_value" style="float: left;"></p><p><label for="custom_field_info_options_int_unit">Unit</label><input type="text" value="M" name="custom_field[value_type][]" id="custom_field_info_options_int_unit" style="float: left;"></p>');}

  if (value=="area"){
    $('div#boolean_options').html('<p><label for="custom_field_info_options_default_area_value_1">Default value</label><input type="text" value="0" size="3" name="custom_field[value_type][]" id="custom_field_info_options_default_area_value_1" style="width:10%;float: left;"><span> X</span><input type="text" value="0" size="3" name="custom_field[value_type][]" id="custom_field_info_options_default_area_value_2" style="width:10%;float: left;"></p><p><label for="custom_field_info_options_int_unit">Unit</label><input type="text" value="M" name="custom_field[value_type][]" id="custom_field_info_options_int_unit" style="float: left;"></p>');}

  if (value=="text"){$('div#boolean_options').html('<p><label for="custom_field_info_options_default_text_value">Default value</label><br><input type="text" value="" name="custom_field[value_type][]" id="custom_field_info_options_default_text_value" class="wide large" style="margin-top: -17px; float: left;"></p>')}

    // if (value=="select"){$('#boolean_options').html('Can be set to one of these options:<br/><div id="TextBoxesGroup"><div id="TextBoxDiv1"><label>1 </label><input type="text" id="textbox1" name="custom_field[value_type][]" style="float: left;"></div></div><input type="button" value=" + Add another option" id="addButton" class="model_save_button" style="float:left;">')}

      $(document).ready(function(){
      var counter = 2;
      $("#addButton").click(function () {
        if(counter>100){
                alert("Only 100 textboxes allow");
                return false;
        }   
        var newTextBoxDiv = $(document.createElement('div')).attr("id", 'TextBoxDiv' + counter);
        newTextBoxDiv.after().html('<label>'+ counter + '</label>' + '<input type="text" name="custom_field[value_type][]" id="textbox' + counter + '" value="" >');
        newTextBoxDiv.appendTo("#TextBoxesGroup");
        counter++;
      });
  });
  });

}

// function customFieldSet(){

// $("#custom_field_value_type1").on("change",function() {
//   var value=$(this).val()
//   if (value=="boolean"){
//   $('#boolean_options').html('<p><label for="custom_field_info_options_default_bool_value">Default value</label><select name="custom_field[value_type][]" id="custom_field_info_options_default_bool_value"><option value="true">True</option><option value="false">False</option></select></p>');}

//   if (value=="integer"){
//     $('#boolean_options').html('<p><label for="custom_field_info_options_default_int_value">Default value</label><input type="text" value="0" size="4" name="custom_field[value_type][]" id="custom_field_info_options_default_int_value"></p><p><label for="custom_field_info_options_int_unit">Unit</label><input type="text" value="M" name="custom_field[value_type][]" id="custom_field_info_options_int_unit"></p>');}

//   if (value=="area"){
//     $('#boolean_options').html('<p><label for="custom_field_info_options_default_area_value_1">Default value</label><input type="text" value="0" size="3" name="custom_field[value_type][]" id="custom_field_info_options_default_area_value_1" style="width:10%"> X<input type="text" value="0" size="3" name="custom_field[value_type][]" id="custom_field_info_options_default_area_value_2" style="width:10%"></p><p><label for="custom_field_info_options_int_unit">Unit</label><input type="text" value="M" name="custom_field[value_type][]" id="custom_field_info_options_int_unit"></p>');}

//   if (value=="text"){$('#boolean_options').html('<p><label for="custom_field_info_options_default_text_value">Default value</label><br><input type="text" value="" name="custom_field[value_type][]" id="custom_field_info_options_default_text_value" class="wide large"></p>')}

//     if (value=="select"){$('#boolean_options').html('Can be set to one of these options:<br/><div id="TextBoxesGroup"><div id="TextBoxDiv1"><label>1 </label><input type="text" id="textbox1" name="custom_field[value_type][]"></div></div><input type="button" value="Add another option" id="addButton" class="button">')}

//       $(document).ready(function(){
//       var counter = 2;
//       $("#addButton").click(function () {
//         if(counter>100){
//                 alert("Only 100 textboxes allow");
//                 return false;
//         }   
//         var newTextBoxDiv = $(document.createElement('div')).attr("id", 'TextBoxDiv' + counter);
//         newTextBoxDiv.after().html('<label>'+ counter + '</label>' + '<input type="text" name="custom_field[value_type][]" id="textbox' + counter + '" value="" >');
//         newTextBoxDiv.appendTo("#TextBoxesGroup");
//         counter++;
//       });
//   });
//   });

// }

// function customFieldModel(){

// $(document).ready(function(){
//   $("#Clients").click(function(){
//     $("#custom_field_applies_to").val("Clients").trigger('change')
//   })
//   $("#Properties").click(function(){
//     $("#custom_field_applies_to").val("Properties").trigger('change')
//   })
//   $("#Jobs").click(function(){
//     $("#custom_field_applies_to").val("Jobs").trigger('change')
//   })
//   $("#Invoices").click(function(){
//     $("#custom_field_applies_to").val("Invoices").trigger('change')
//   })
//   $("#Quotes").click(function(){
//     $("#custom_field_applies_to").val("Quotes").trigger('change')
//   })
//   $("#User").click(function(){
//     $("#custom_field_applies_to").val("User").trigger('change')
//   })
 
// })
// }

// In setting pannel within work setting invoice part

function setDefaultValue(value){
  if (value=="")
    {
      $("#default_invoice_net_other").css('display','block')
    }
    else
    { 
      $(".set_other_value").val("")
      $("#default_invoice_net_other").css('display','none')
    }
}


function manullyGecode(){


      var geocoder = new google.maps.Geocoder();
    function geocodePosition(pos) {
    geocoder.geocode({
    latLng: pos
    }, function(responses) {
    if (responses && responses.length > 0) {
    updateMarkerAddress(responses[0].formatted_address);
    } else {
    updateMarkerAddress('Cannot determine address at this location.');
    }
    });
    }
    function updateMarkerStatus(str) {
    document.getElementById('markerStatus').innerHTML = str;
    }
    function updateMarkerPosition(latLng) {
      $('#latitude').val(latLng.lat());
      $('#longitude').val(latLng.lng());
    }
    function updateMarkerAddress(str) {
    document.getElementById('address').innerHTML = str;
    }
    function initialize() {
    var latitude = $('#latitude').val()
    var longitude = $('#longitude').val()
    if (latitude){
      var latLng = new google.maps.LatLng(latitude, longitude);
      }
      else
      {
      var latLng = new google.maps.LatLng(22.70526763541825, 75.84167733459469);
      }
    var map = new google.maps.Map(document.getElementById('mapCanvas'), {
    zoom: 8,
    center: latLng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    var marker = new google.maps.Marker({
    position: latLng,
    title: 'Point A',
    map: map,
    draggable: true
    });
    // Update current position info.
    updateMarkerPosition(latLng);
    geocodePosition(latLng);
    // Add dragging event listeners.
    google.maps.event.addListener(marker, 'dragstart', function() {
    updateMarkerAddress('Dragging...');
    });
    google.maps.event.addListener(marker, 'drag', function() {
    updateMarkerStatus('Dragging...');
    updateMarkerPosition(marker.getPosition());
    });
    google.maps.event.addListener(marker, 'dragend', function() {
    updateMarkerStatus('Drag ended');
    geocodePosition(marker.getPosition());
    });
    }
    // Onload handler to fire off the app.
    google.maps.event.addDomListener(window, 'load', initialize); 

   if (window.location.href.indexOf('reload')==-1) {
       window.location.replace(window.location.href+'?reload');
    }   
   
}


function checkMarked(value,type){
  var data=$("#"+value).is(':checked');
  var name=$("#"+value).attr("name");
  $("#mydiv_loader").css("display","block")
  $.ajax({
    type: "get",
    url: "/pdf_settings",
    data: {data: data , name: name,type: type}
   });
  
}


// job_work_configuration

function visitingSetting(){
   $("#work_configuration_visit_title_template").removeClass("disabled");
   document.getElementById('visit_settings_details').style.display = 'block';
}

// Edit Quote Submit
function EditQuoteSubmit(){
$("#quote_edit").click(function(){
    if (workValidation()){
      $('.edit_quote').submit();
    }
  })

}


function actionReload(){
    if (window.location.href.indexOf('reload')==-1) {
     window.location.replace(window.location.href+'?reload');
  }
}

function EditFormSubmit(){

$("#invoice_edit").click(function(){
  if (workValidation()){ 
    $('.edit_invoice').submit();}  
  })
}


$(document).ready(function() {
 
  $("#example_length").hide();
  $('input[type=search]').attr('placeholder','Search properties...');

   // Setup - add a text input to each footer cell
    $('#property_index_view tfoot th').each( function () {
        var title = $('#property_index_view thead th').eq( $(this).index() ).text();
        $(this).html( '<input type="text" style="width:80%;"placeholder="" />' );
    } );

   $('#property_index_view').DataTable({"columnDefs": [{ "orderable": false, "targets": 0 }],"bPaginate": false});
    // DataTable
    var table = $('#property_index_view').DataTable();

    // Apply the search
    table.columns().every( function () {
        var that = this;
        $( 'input', this.footer() ).on( 'keyup change', function () {
            if ( that.search() !== this.value ) {
                that
                    .search( this.value )
                    .draw();
            }
        } );
    } );
} );


$("#classified_license_licensed").change(function(){
  $("#classified_license_info").css('display','block');
})
$("#classified_license_unlicensed").change(function(){
  $("#classified_license_info").css('display','none');
})

// dashboard javascript 
$(".message_display").click(function(){
    $(".loader_display").css("display","block");
  })


function ChangeSelectClientUser(){ 
    $("#select_users_clients").change(function(){
      var value= $(this).val();
      if(value== "users")
        {
          $(".clients_select").css("display","none");  
          $(".users_select").css("display","block");  
        }
      else
        {
          $(".users_select").css("display","none");  
          $(".clients_select").css("display","block");  
        }
    })


    $("#select_users_clients_call").change(function(){
      var value= $(this).val();
      if(value== "users")
        {
          $(".clients_select_call").css("display","none");  
          $(".users_select_call").css("display","block");  
        }
      else
        {
          $(".users_select_call").css("display","none");  
          $(".clients_select_call").css("display","block");  
        }
    })
  }


function nameFunction()
{
  $("#edit-name").css("display","none");
  $(".l-name").css("display","none");
  $("#l-name").css("display","block");
}
function descFunction()
{
  $("#edit-description").css("display","none");
  $(".l-description").css("display","none");
  $("#l-description").css("display","block");
}
function productFunction()
{
  $("#edit-product_model").css("display","none");
  $(".l-product_model").css("display","none");
  $("#l-product_model").css("display","block");
}
function vendorFunction()
{
  $("#edit-vendor_part").css("display","none");
  $(".l-vendor_part").css("display","none");
  $("#l-vendor_part").css("display","block");
}

function vendorNameFunction()
{
  $("#edit-vendor_name").css("display","none");
  $(".l-vendor_name").css("display","none");
  $("#l-vendor_name").css("display","block");
}
function quantityFunction()
{
  $("#edit-item_quantity").css("display","none");
  $(".l-item_quantity").css("display","none");
  $("#l-item_quantity").css("display","block");
}
function unitFunction()
{
  $("#edit-unit").css("display","none");
  $(".l-unit").css("display","none");
  $("#l-unit").css("display","block");
}
function valueFunction()
{
  $("#edit-value").css("display","none");
  $(".l-value").css("display","none");
  $("#l-value").css("display","block");
}
function vendorurlFunction()
{
  $("#edit-vendor_url").css("display","none");
  $(".l-vendor_url").css("display","none");
  $("#l-vendor_url").css("display","block");
}
function categoryFunction()
{
  $("#edit-category").css("display","none");
  $(".l-category").css("display","none");
  $("#l-category").css("display","block");
}
function imageFunction()
{
  $("#edit-image").css("display","none");
  $(".l-image").css("display","none");
  $("#l-image").css("display","block");
}
function locationFunction()
{
  $("#edit-location").css("display","none");
  $(".l-location").css("display","none");
  $("#l-location").css("display","block");
}

function itemFunction()
{
  $("#edit-item").css("display","none");
  $(".l-item").css("display","none");
  $("#l-item").css("display","block");
}

function descriptionFunction()
{
  $("#edit-description").css("display","none");
  $(".l-description").css("display","none");
  $("#l-description").css("display","block");
}

function purchasePrice()
{
$("#edit-purchase_price").css("display","none");
$(".l-purchase_price").css("display","none");
$("#l_p_price").css("display","block");
}


function purchaseCode()
{
$("#edit-purchase_code").css("display","none");
$(".l-purchase_code").css("display","none");
$("#l_p_code").css("display","block");
}

function salePrice(){
$("#edit-sale_price").css("display","none");
$(".l-sale_price").css("display","none");
$("#l_s_price").css("display","block");
}

function saleCode(){
$("#edit-sale_code").css("display","none");
$(".l-sale_code").css("display","none");
$("#l_s_code").css("display","block");
}

function profitFunction(){
$("#edit-l_profit").css("display","none");
$(".l-profit").css("display","none");
$("#l_profit").css("display","block");
}
function marginFunction(){
$("#edit-l_margin").css("display","none");
$(".l-margin").css("display","none");
$("#l_margin").css("display","block");  
}

$(document).on('click', '#check-vendors-system', function(){
    
    if($(this).is(':checked')) 
      { $(".vendor-index-check").prop('checked', true); }
    else
      {  $(".vendor-index-check").prop('checked', false); }
  })
$(document).on('click', '.vendor-index-check', function(){
    $("#check-vendors-system").prop('checked', false);
  })

  $(document).ready(function() {
    $('#vendors-list tfoot th').each( function () {
        var title = $(this).text();
        $(this).html( '<input type="text" style="width:80%; placeholder="Search '+title+'" />' );
    } );
    $('#vendors-list').DataTable({"columnDefs": [{ "orderable": false, "targets": 0 }]});
   var table = $('#vendors-list').DataTable();
    table.columns().every( function () {
        var that = this;
 
        $( 'input', this.footer() ).on( 'keyup change', function () {
            if ( that.search() !== this.value ) {
                that
                    .search( this.value )
                    .draw();
            }
        } );
    } );
  } );