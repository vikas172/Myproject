function AddMore(){

 $(".validate_email").keyup(function(){ 
   $("#addScnt1").show()
  }); 
  $(".validate_phone").keyup(function(){
   $("#addScnt").show()
  });


  $(".client_create").click(function(){
    if (validate()){
    $('#new_client').submit();}
  })
  $(".client_edit").click(function(){
  if (validate()){
   $('.edit_client').submit();}
  })



$('.mobile_number_team_member').keyup(function() {
  foo = $(this).val().split("-").join(""); // remove hyphens

      foo = foo.match(new RegExp('.{1,4}$|.{1,3}', 'g')).join("-");

      $(this).val(foo);
 
  });


/* this code for check box by add custom field of clients START*/

  $("#custom_field_value_type_check").click(function(){
 if($(this).prop("checked") == true){
  document.getElementById("custom_field_value_type_check_value").value = "true";
 }
 else{
  document.getElementById("custom_field_value_type_check_value").value = "false";
  
 }
})

/*END*/
// $(function(){
// var f1 = new LiveValidation('client_first_name');
// f1.add( Validate.Presence );
// var f2 = new LiveValidation('client_last_name');
// f2.add( Validate.Presence );
// var f3 = new LiveValidation('client_company_name');
// f3.add( Validate.Presence );
// })
 $(function() {

    var scntDiv = $('#p_scents');
    var i = $('#p_scents p').size();
    $("#addScnt").on("click",function(){
       $(".first_phone").show()
        var j=i+1;
        $('<p style="height: 43px;"><label for="p_scnts"><a class="star click_ignore phone_star" href="" data-tooltip="Make Primary" data-remote="true" id="primary_phone_a_'+j+'" data-onclick-primary-star="true" style="display: inline-block;"></a><input type="hidden" id="primary_phone_'+j+'" size="20" name="primary_phone[]" value="false"/><select name="ph_initial[]" id="p_scnt"><option value="Main">Main</option><option value="Work">Work</option><option value="Mobile">Mobile</option><option value="Home">Home</option><option value="Fax">Fax</option><option value="Other">Other</option></select>&nbsp;&nbsp;<input type="text" id="p_scnt" size="20" name="ph_number[]" value="" placeholder="phone number..." /></label><b class="remScnt btn btn" style="margin-top: -7%;">-</b></p>').appendTo(scntDiv);
        i++;
    });

    
    $(document).on("click",".phone_star", function () {
      var value = this.id.split("_")[3]
      $(".phone_star").each(function(){
        if (this.id.split("_")[3] == value){
          $("#"+this.id).addClass('on')
          $("#primary_phone_"+value).val(true)
        }
        else{
          $("#"+this.id).removeClass('on') 
          $("#primary_phone_"+this.id.split("_")[3]).val(false)
        }
      })
    })

    $("#p_scents").on("click",".remScnt", function(){
        // items which need to be deleted are encapsulated within the parent item. You can use parent() to remove everything.
        $(this).parent().remove();
        i--;
    });
});


  $(function() {
      var scntDiv = $('#p_scents1');
      var i = $('#p_scents1 p').size();
      
      $("#addScnt1").on("click",function(){
        var j=i+1;
         $(".first_email").show()
        $('<p><label for="p_scnts"><a class="star click_ignore email_star" href="" data-tooltip="Make Primary" data-remote="true" id="primary_email_a_'+j+'" data-onclick-primary-star="true" style="display: inline-block;"></a><input type="hidden" id="primary_email_'+j+'" size="20" name="primary_email[]" value="false"/><select name="email_initial[]" id="p_scnt1"><option value="Main">Main</option><option value="Work">Work</option><option value="Personal">Personal</option><option value="Other">Other</option></select>&nbsp;&nbsp;<input type="email" id="p_scnt1" size="20" name="email[]" value="" placeholder="email address..." pattern="^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$" class="validate_email"/></label><b class="remScnt1 btn btn" style="margin-top: -7%;">-</b></p>').appendTo(scntDiv);
          i++;
      });

      $(document).on("click",".email_star", function () {
        var value = this.id.split("_")[3]
        $(".email_star").each(function(){
          if (this.id.split("_")[3] == value){
            $("#"+this.id).addClass('on')
            $("#primary_email_"+value).val(true)
          }
          else{
            $("#"+this.id).removeClass('on') 
            $("#primary_email_"+this.id.split("_")[3]).val(false)
          }
        })
      })

      $("#p_scents1").on("click",".remScnt1", function(){
          // items which need to be deleted are encapsulated within the parent item. You can use parent() to remove everything.
          $(this).parent().remove();
          i--;
      });
  });
/* 
    Text fields 
*/
$(function(){
  $(document).on('focus', 'div.form-group-options div.input-group-option:last-child input', function(){
    var sInputGroupHtml = $(this).parent().html();
    var sInputGroupClasses = $(this).parent().attr('class');
    $(this).parent().parent().append('<div class="'+sInputGroupClasses+'">'+sInputGroupHtml+'</div>');
  });
  
  $(document).on('click', 'div.form-group-options .input-group-addon-remove', function(){
    $(this).parent().remove();
  });
});

/* 
    Selects 
*/
$(function(){
        
  var values = new Array();
  
  $(document).on('change', '.form-group-multiple-selects .input-group-multiple-select:last-child select', function(){
        
    var selectsLength = $('.form-group-multiple-selects .input-group-multiple-select select').length;
    var optionsLength = ($(this).find('option').length)-1;
    
    if(selectsLength < optionsLength){
      var sInputGroupHtml = $(this).parent().html();
      var sInputGroupClasses = $(this).parent().attr('class');
      $(this).parent().parent().append('<div class="'+sInputGroupClasses+'">'+sInputGroupHtml+'</div>');  
    }
    
    updateValues();
    
  });
  
  $(document).on('change', '.form-group-multiple-selects .input-group-multiple-select:not(:last-child) select', function(){
    
    updateValues();
    
  });
  
  $(document).on('click', '.input-group-addon-remove', function(){
    $(this).parent().remove();
    updateValues();
  });
  
  function updateValues()
  {
    values = new Array();
    $('.form-group-multiple-selects .input-group-multiple-select select').each(function(){
      var value = $(this).val();
      if(value != 0 && value != ""){
        values.push(value);
      }
    });
    
    $('.form-group-multiple-selects .input-group-multiple-select select').find('option').each(function(){
      var optionValue = $(this).val();
      var selectValue = $(this).parent().val();
      if(in_array(optionValue,values)!= -1 && selectValue != optionValue)
      {
        $(this).attr('disabled', 'disabled');
      }
      else
      {
        $(this).removeAttr('disabled');
      }
    });
  }
  
  function in_array(needle, haystack){
    var found = 0;
    for (var i=0, length=haystack.length;i<length;i++) {
      if (haystack[i] == needle) return i;
      found++;
      }
      return -1;
  }
});


 $(function () {
      $(".repeat").on('click', function (e) {
          e.preventDefault();
          var $self = $(this);
          $self.before($self.prev('table').clone());
          
      });
    });

}


$(document).ready(function(){

    $(function($) {
    $("tr[data-link]").click(function() {
    window.location = this.dataset.link
    });
    })

});

function exportAllTag(i){
    var arr = [];
    if ($( "#tag_expo_"+i ).hasClass('selected')) {
        $("#tag_expo_"+i ).removeClass("selected");
        $("#start_expo").find('.selected').each(function(){
          arr.push($(this).attr("value"))
        });
      $('.name').val(arr);
    } else{
        $( "#tag_expo_"+i ).addClass( "selected" );
        $("#start_expo").find('.selected').each(function(){
          arr.push($(this).attr("value"))
        });
        $('.name').val(arr);
    };    
  }


  function getAllTag(i){
    var arr = [];

    if ($("#tag_selectors a").hasClass('selected')) {
      $("#tag_selectors a").removeClass("selected");
    };

    if ($( "#tag_"+i ).hasClass('selected')) {
        $("#tag_"+i ).removeClass("selected");
        $("#start").find('.selected').each(function(){
          arr.push($(this).attr("value"))
        });
        $.ajax({
          type: "POST",
          url: "/search_tag",
          data: {name: arr}
         });
    } else{
        $( "#tag_"+i ).addClass( "selected" );
        $("#start").find('.selected').each(function(){
          arr.push($(this).attr("value"))
        });
        $.ajax({
          type: "POST",
          url: "/search_tag",
          data: {name: arr}
         });
    };    
  }

  function getTag(i,name){
    var arr=[];
   if ($("#tag_selectors1 a").hasClass('selected')) {
      $("#tag_selectors1 a").removeClass("selected");
    };

  // $("#tag_selectors a").removeClass("selected");
  if ($( "#tag1_"+i ).hasClass( "selected" ))
  {
    $( "#tag1_"+i ).removeClass( "selected" );
    $.ajax({
      type: "POST",
      url: "/search_tag",
      data: {name: ""}
     });

  }
  else{
    $("#tag_selectors a").removeClass("selected");
    $( "#tag1_"+i ).addClass( "selected" );


  arr.push(name)
    $.ajax({
      type: "POST",
      url: "/search_tag",
      data: {name: arr}
     }); 
      }
  }


function deleteTag(name,id){

var name=name
var id= id
  $.ajax({
    type: "POST",
    url: "/tag_delete",
    data: {name: name, client_id: id}
   }); 
  
}


function deletePropertyTag(name,id){

var name=name
var id= id
  $.ajax({
    type: "POST",
    url: "/properties/tag_delete",
    data: {name: name, property_id: id}
   }); 
  
}




function searchClient(value){
   var arr=[]
 $("#tags_container").find('.selected').each(function(){
    arr.push($(this).attr("value"))
  })
 $(".sort_select_clients").attr('disabled', 'disabled');
  var data =value
  if (data==""){
    $('.sort_select_clients').removeAttr('disabled');
    
  }
    $.ajax({
      type: "POST",
      url: "/client_search",
      data: {q: data,tags: arr}
     });

}


function sortClientFLName(value,client){
 var  data=value
 var arr=[]
 $("#tags_container").find('.selected').each(function(){
    arr.push($(this).attr("value"))
  });
$.ajax({
      type: "POST",
      url: "/client_search",
      data: {sort_by: data,tags: arr}
     }); 
}
$(document).ready(function(){

  $( "#timepicker" ).timepicker();
  $( "#timepicker1" ).timepicker();
  $(".datepicker").datepicker({ dateFormat: 'yy-mm-dd' })
})

$(document).ready(function(){
  $('input[type="checkbox"]').click(function(){
      if($(this).find('input:checkbox').prop("checked", true)){
          $(".toggle-append").toggle();
      }
  });
});

function workClient(){ 
$('div[id^=tab]').hide();
$('#tab1').show();
$('.tab_selector a').click(function () {
   var tab_id = $(this).attr('href'); 
   $('div[id^=tab]').hide();
   $(tab_id).show(); 
   return false;
});
}


function validateEmail(email) {
 
  var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
   return re.test(email);
}

function validate(){
  var k;
  var i=0; 
 $("#result").text("");
 var abc=($(".validate_email").val())
  if (abc!=""){
    $(".validate_email").each(function(){
      
      var email = $(this).val();
      k = validateEmail(email)
        if (k) {
         
        } 
        else {
          i++;
         $("#result").text("Emails address must be a valid format ");
         $("#result").css("color", "red");
        }
       
    
     })
    if (i==0){
      return true;
    }
    if (i>0)
      {
        k=false
        $("#result").text("Emails address must be a valid format ");
        $("#result").css("color", "red");
      }
   return k;
  }
  else
  {
    return true;
  }
}
// Upload image attachment in client show view
function replace(hide, show, id) {
  $( '#'+hide ).replaceWith( $('#'+show) );
 document.getElementById(show).style.display="block";      
}

function attachmentAndDelete(){
  $('.notes_images').click(function(event){
    $('#attachment_display_'+$(this).attr("id")).modal()
    event.stopImmediatePropagation();
  });

  $(".modal").click(function(event){
    event.stopImmediatePropagation();
  })

var checkboxes = document.getElementsByTagName('input');

for (var i=0; i<checkboxes.length; i++)  {
  if (checkboxes[i].type == 'checkbox')   {
    checkboxes[i].checked = false;
  }
}
  $(document).on('change','#delete_model_client input:checkbox',function () {
     var count=0;
      $(".client_delete_number").each(function(){
       if (parseInt($(this).html()) > 0){
        count++;
       }
      })
      
        if($('input:checkbox:checked').length >= count) {
            $('#btn2').removeClass('hide')
        }
        else {
            $('#btn2').addClass('hide')
        }

    });
}


function checkCustomBox(){

  $("#custom_field_value_type_check").click(function(){
    if($(this).prop("checked") == true){
     document.getElementById("custom_field_value_type_check_value").value = "true";
    }
    else{
      document.getElementById("custom_field_value_type_check_value").value = "false";
  
    }
  });
}

function paymentClient(){
  $("#payment_invoice_pay_method").on("change",function(){
   var payment= $(this).val();
   if (payment=="cheque"){
      $("#cheque_number").show();
      $("#cc_transaction_number").hide();
      $("#confirmation_number").hide();
      $("#transaction_number_text").val("");
      $("#confirmation_number_text").val("");
   }
    if (payment=="credit_card"){
      $("#cheque_number").hide();
      $("#cc_transaction_number").show();
      $("#confirmation_number").hide();
      $("#cheque_number_text").val("");
      $("#confirmation_number_text").val("");
   }
    if (payment=="bank_transfer"){
      $("#cheque_number").hide();
      $("#cc_transaction_number").hide();
      $("#confirmation_number").show();
       $("#cheque_number_text").val("");
       $("#transaction_number_text").val("");
   }
   if (payment=="other"){
      $("#cheque_number").hide();
      $("#cc_transaction_number").hide();
      $("#confirmation_number").hide();
   }
   if (payment=="cash"){
      $("#cheque_number").hide();
      $("#cc_transaction_number").hide();
      $("#confirmation_number").hide();
   }
   if (payment=="money_order"){
      $("#cheque_number").hide();
      $("#cc_transaction_number").hide();
      $("#confirmation_number").hide();
   }
  });

  $("#payment_invoice_transaction_type").on("change",function(){
   var payment= $(this).val();
   if (payment=="initial_balance"){
      $("#payment_client_entry").hide();
      $("#payment_client").hide();
   }
    if (payment=="Payment"){
      $("#payment_client_entry").show();
      $("#payment_client").show();
   }
    if (payment=="Deposit"){
      $("#payment_client_entry").show();
      $("#payment_client").show();
   }
  });

  $( ".datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });
}



function phoneFormat(){


$('.mobile_number_team_member').keyup(function() {
  foo = $(this).val().split("-").join(""); // remove hyphens

      foo = foo.match(new RegExp('.{1,4}$|.{1,3}', 'g')).join("-");

      $(this).val(foo);
 
  });


  $("#change-service").click(function(){
    $("#change-obtain-number").css("display","block");
    $("#service-phone-number").css("display","none");
  })
}