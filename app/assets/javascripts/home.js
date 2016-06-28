function teamAdd()
{

var login=$("#login_access").prop("checked")==true
if (login){
  $(".login_access_sucess").show()
  $("#detailed_permissions").show();
}
else{
  $(".no_login_access_permission").show()
  $("#detailed_permissions").hide()
}


$(document).ready(function(){
  $('#login_access').click(function(){
    if($(this).prop("checked") == true){
      $(".payment_login_access").show()
      $(".useless_login_access").hide()
      $('.login_access h3 img').attr('src', '//d3ey4dbjkt2f6s.cloudfront.net/assets/app/icons/user_green_16x16-287c7d3a069f06e6f09464d37d235593.png')  
      $("#detailed_permissions").show()
    }
    else if($(this).prop("checked") == false){
      $(".payment_login_access").hide()
      $(".useless_login_access").show()
      $('.login_access h3 img').attr('src', '//d3ey4dbjkt2f6s.cloudfront.net/assets/app/icons/user_black_16x16-ce035ca00fe805c27bcaa18152820a8c.png');
      $("#detailed_permissions").hide()
    }
  });


$("#user_permissions_clients").click(function(){
  if($(this).prop("checked") == true){
    $('#user_permissions_quotes').prop('disabled', false);
    $('#user_permissions_invoices').prop('disabled', false);
    $('#user_permissions_work_orders').prop('disabled', false);
    $('#user_permissions_notes').prop('disabled', false);
    $('.require_clients').prop('disabled', false);
    $( ".diplay_client_properties_detail" ).removeClass( "invisible" )

    
  }
  else{
    $('#user_permissions_quotes').prop('disabled', true);
    $('#user_permissions_invoices').prop('disabled', true);
    $('#user_permissions_work_orders').prop('disabled', true);
    $('#user_permissions_notes').prop('disabled', true);
    $('.require_clients').prop('disabled', true);
    $( ".diplay_client_properties_detail" ).addClass( "invisible" )
    $(".has_pricing").hide();
    $(".not_has_pricing").hide();
    $(".diplay_quotes_detail").addClass( "invisible" )
    $(".diplay_invoices_detail").addClass( "invisible" )
    $(".display_work_orders_detail").addClass( "invisible" )
    $("#user_permissions_notes_rwd").hide()
    $(".check_box_unselect").removeAttr('checked');
    $("#user_permissions_clients_index").removeAttr('checked');
    $("#user_permissions_quotes_index").removeAttr('checked');
    $("#user_permissions_invoices_index").removeAttr('checked');
    $("#user_permissions_work_orders_index").removeAttr('checked');
  }
})
$("#user_permissions_quotes").click(function(){
  if($(this).prop("checked") == true){
    $(".diplay_quotes_detail").removeClass( "invisible" )
  }
  else
  {
    $(".diplay_quotes_detail").addClass( "invisible" )
  }
})

$("#user_permissions_invoices").click(function(){
  if($(this).prop("checked") == true){
    $(".diplay_invoices_detail").removeClass( "invisible" )
  }
  else
  {
    $(".diplay_invoices_detail").addClass( "invisible" )
  }

})
$("#user_permissions_work_orders").click(function(){
  if($(this).prop("checked") == true){
    $(".display_work_orders_detail").removeClass( "invisible" )
  }
  else
  {
    $(".display_work_orders_detail").addClass( "invisible" )
  }

})
$("#user_permissions_notes").click(function(){
  if($(this).prop("checked") == true){
    $("#user_permissions_notes_rwd").show()
    $(".display_attachment_notes_detail").removeClass( "invisible" )
  }
  else
  {
    $(".display_attachment_notes_detail").addClass( "invisible" )
  }

})


$("#user_permissions_pricing").click(function(){
  if($(this).prop("checked") == true){
    $(".has_pricing").show();
    $(".not_has_pricing").hide();
  }
  else{
    $(".has_pricing").hide();
    $(".not_has_pricing").show();
  }
})

});

$("#user_permissions_work_orders").click(function(){
  if($(this).prop("checked") == false){
  $("#user_permissions_work_orders_index").removeAttr('checked'); }
})
$("#user_permissions_invoices").click(function(){
   if($(this).prop("checked") == false){
  $("#user_permissions_invoices_index").removeAttr('checked'); }
})
$("#user_permissions_quotes").click(function(){
   if($(this).prop("checked") == false){
  $("#user_permissions_quotes_index").removeAttr('checked'); }
})
$("#user_permissions_clients").click(function(){
   if($(this).prop("checked") == false){
  $("#user_permissions_clients_index").removeAttr('checked'); }
})

$('.mobile_number_team_member').keyup(function() {
  foo = $(this).val().split("-").join(""); // remove hyphens

      foo = foo.match(new RegExp('.{1,4}$|.{1,3}', 'g')).join("-");

      $(this).val(foo);
 
  });

}


window.setTimeout(function() {
    $("#flash_notice_team_member").fadeTo(500, 0).slideUp(500, function(){
        $(this).remove(); 
    });
}, 5000);



function imagePreviewDisplay(input) {
  $("#blah").css("display","block");
  $("#preview_image").css("display","none");
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#blah')
                .attr('src', e.target.result)
                .width(150)
                .height(200);
        };

        reader.readAsDataURL(input.files[0]);
        $("#company_company_logo").change(function(){
  $('.jcrop-holder').data('Jcrop').destroy();
})
    }
  }

  function showCoords(c)
  {
      // variables can be accessed here as
       //c.x, c.y, c.x2, c.y2, c.w, c.h
       $("#user_edit_crop_x").val(c.x);
       $("#user_edit_crop_y").val(c.y);
       $("#user_edit_crop_x2").val(c.x2);
       $("#user_edit_crop_y2").val(c.y2);
       $("#user_edit_crop_w").val(c.w);
       $("#user_edit_crop_h").val(c.h);
       $("#jcrop_holder_width").val($(".jcrop-holder").css('width'));
       $("#jcrop_holder_height").val($(".jcrop-holder").css('height'));
      
  };


  function viewDisplayMessage(id){
    $.ajax({
    type: "POST",
    url: "/message_show/"+id
   });
  }


  function emailShowView(id){
    $.ajax({
    type: "GET",
    url: "/email_notifications/"+id
   });
  }

  function messageShowView(id,data){
    $.ajax({
    type: "GET",
    url: "/conversations/"+id,
    data: {data: data }
   });
  }