
function AddInvoiceJs(){

   $(".invoice_create").click(function(){
    if (workValidation()){
      $('#new_invoice').submit();}
  })
  
$(function($) {
  $("tr[data-link]").click(function() {
    window.location = this.dataset.link
  });
})


$(function($) { 

$( "#entrydate-datepicker-invoice" ).datepicker({ dateFormat: 'yy-mm-dd' });
$( "#issueddate-datepicker-invoice" ).datepicker({ dateFormat: 'yy-mm-dd' });
$( ".invoice_due_date1" ).datepicker({ dateFormat: 'yy-mm-dd' });
});

$(document).ready(function(){
    $("#invoice_payment_method_type").change(function(){
        if($("#invoice_payment_method_type").val()){
          switch ($(this).val()) {
            case "Cash":
                $(".hidden_option").addClass("hidden")
                break;
            case "Credit":
                $("td.hidden_option").text("Transaction #")
                $(".hidden_option").removeClass("hidden")
                break;
            case "Cheque":
                $("td.hidden_option").text("Cheque #")
                $(".hidden_option").removeClass("hidden")
                break;
            case "Bank Transfer":
                $("td.hidden_option").text("Confirmation #")
                $(".hidden_option").removeClass("hidden")
                break;
            case "Money Order":
                $(".hidden_option").addClass("hidden")
                break;
            case "Other":
                $(".hidden_option").addClass("hidden")
                break;
          }
         $("#invoice_payment_method_type").val(this.value);
        }            
    });        
});



$("#invoice_payment").change(function(){
var value= $("#invoice_payment").val()
if (value == "Custom"){
 $("#invoice_due_date").removeAttr( "style" )
}
else{
  $("#invoice_due_date").attr("style","display:none;")
}
})

}


function searchClientInvoiceModel(value){
  var data = value

  $.ajax({
          type: "POST",
          url: "/search_invoice_client",
          data: {q: data}
         }); 
}

function sortByInvoiceFirstLast(value){
   var data = value
    $.ajax({
    type: "POST",
    url: "/invoice_sort",
    data: {sort_by: data}
   });
  }


function searchInvoiceIndex(value){

  var data =value
   data=value
    if (!isNaN(data)){
      searchTable('#'+data);
    }
    else
    {
      searchTable(data);
    }
 

  function searchTable(inputVal)
  {
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


function sortByOutstanding(value){

  var data =value
  $.ajax({
    type: "POST",
    url: "/sort_invoice_outstanding",
    data: {sort_by_month: data}
   });

}

function sortByInvoiceTime(value){


   var data = value
    $.ajax({
    type: "POST",
    url: "/sort_invoice_time",
    data: {sort_by_month: data}
   });
  }

function PaymentMethod(){
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
  })
  $( ".datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });
  var invoice_total=$(".very_important").html(); 
  var invoice_totals=invoice_total.replace(/\$/g, '');  
  $("#payment_amount").val(invoice_totals);
}