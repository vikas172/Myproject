// $('#ratygem').raty({hints: ['Unlikely', 'Maybe', 'Likely', 'Very Likely', 'Certain']});
function ProgressBar() {
  (function() {
      
  var bar = $('.bar');
  var percent = $('.percent');
  var status = $('#status');
  
  
  $('#image_upload_form').ajaxForm({
      beforeSend: function() {
        var attach=$("#inputattachment").val();
        $("#note").val("");

        $("#attachment_field").hide();
        $(".cancel").hide()
        $(".attach_files").show();
        if (attach!=""){
        $('.progress_div').show();}
          status.empty();
          var percentVal = '0%';
          bar.width(percentVal)
          percent.html(percentVal);
      },
      uploadProgress: function(event, position, total, percentComplete) {
          var percentVal = percentComplete + '%';
          bar.width(percentVal)
          percent.html(percentVal);
      },
      success: function() {

          var percentVal = '100%';
          bar.width(percentVal)
          percent.html(percentVal);
      },
    complete: function(xhr) {
      status.html(xhr.responseText);
    }
  }); 

  });  
}    


function AddMoreWork() {
    var scntDiv = $('#add_more_work');
    var i = $('#add_more_work p').size();
    var countries_starting_with_A = "<%= raw @service_products.to_json %>";
    $("#addScnt").on("click",function(){
      var j=i+1;
      $('<p><label for="p_scnts"><input type="text" id="p_name_'+j+'" size="20" name="name[]" value="" placeholder="name..." style="margin-left: 40px; width: 14%;" class="work_name text_inbuild"/><textarea style="height: 47px; margin-left: 40px; width: 46%;" placeholder="description..." name="description[]" id="p_description_'+j+'" class="work_description"></textarea><input type="text" id="p_quantity_'+j+'" size="20" name="quantity[]" value="" style="width: 4%; margin-left: 8%;" onchange="AddQuantity(this.id)" maxlength="5"/>$<input type="text" id="p_unit_cost_'+j+'" size="20" name="unit_cost[]" placeholder="0.00" style="width: 4%; margin-left: 1.7%;" onchange="AddUnitCost(this.id)" maxlength="5"/>$<input type="text" id="p_total_'+j+'" size="20" name="total[]" placeholder="0.00"style="margin-left: 1.4%; width: 6%; " class="p_total" readonly="readonly"/></label> <b style="margin-top: -104px; width: 1%;" href="" class="remScnt btn btn">-</b></p>').appendTo(scntDiv);
        // $("#p_name_" + j).autocomplete({
        //     source: countries_starting_with_A
        // });
        $("#p_name_" + j).autocomplete({
        source: countries_starting_with_A,
        minLength: 1,
        select: function(event, ui) {
            // feed hidden id field
            $("#p_name_" + j).val(ui.item.value);
            // update number of returned rows
            
        },
        open: function(event, ui) {
            // update number of returned rows
            var len = $('.ui-autocomplete > li').length;
            $("#p_name_" + j).html('(#' + len + ')');
        },
        close: function(event, ui) {
            // update number of returned rows
            $("#p_name_" + j).html('');
        },
        // mustMatch implementation
        focus: function (event, ui) {
            if (ui.item === null) {
                $(this).val('');
                $("#p_name_" + j).val('');
            }
            $("#p_description_" + j).val(ui.item.description);
            $("#p_quantity_" + j).val(ui.item.unit_cost);
            $("#p_unit_cost_"+j).val(1);
            unit = $("#p_quantity_"+j).val();
            unit_value = $("#p_unit_cost_"+j).val();
            total =unit*unit_value;
            $("#p_total_"+j).val(total);
            
        }
    });
        i++;
    });

    $("#add_more_work").on("click",".remScnt", function(){
      if (i>1){
        $(this).parent().remove();
        i--;
      }
    });

$('#ratygem').raty({ score: 1,hints: ['Unlikely', 'Maybe', 'Likely', 'Very Likely', 'Certain']});
}
function AddQuantity(j) {
var a =$("#"+j).val()
var c=j.lastIndexOf("_")+1
var d=j.substr(c,4)
var b=$("#p_unit_cost_"+d).val()
if ((!isNaN(b)) && (b != "") && (!isNaN(a)))
{

$('#p_total_'+d).val((a*b).toFixed(2));
}
else
{
  $('#p_total_'+d).val(0.00);
}
AddTotal()

}

function AddUnitCost(j) {
 var b =$("#"+j).val()
 var c=j.lastIndexOf("_")+1
 var d=j.substr(c,4)
 var a=$("#p_quantity_"+d).val()
if (!isNaN(b)&& (!isNaN(a))){
$('#p_total_'+d).val((a*b).toFixed(2));
}
else
{
 $('#p_total_'+d).val(0.00) 
}
AddTotal()
}

function AddTotal(){
 
    var sub_total= 0

    $(".p_total").each(function(){
    sub_total= parseFloat(sub_total) + parseFloat($(this).val())
    
   })

if (sub_total==0){
   $("#total_quote").html(0.00)
}

var discount_check = $("#quote_discount_rate").val()

if (discount_check==""){
  $("#quote_discount").html(0.00)
}
if (!isNaN(sub_total))
 {
    $("#quote_subtotal").html(sub_total.toFixed(2));}
    var dis = $("#quote_discount_rate").val()

    if (dis !=0.00)
      {  

        var discount= parseFloat(dis)
        if (!isNaN(discount)){
        $("#quote_discount").html(discount.toFixed(2));
        }
        else
        {
           $("#quote_discount").html(0.00);
        }
        if (sub_total!=0)
         {
            var tax_calculate= parseFloat(sub_total)-parseFloat(discount)
            var tax_value= $("#quote_stripped_tax").val()
          } 
      
        if (!isNaN(sub_total))
         {
            if ((tax_value!=undefined) && (tax_value!=""))
              {
                if (!isNaN(tax_value)){
              var tax= (parseFloat(tax_calculate)*parseFloat(tax_value))/100
              if (!isNaN(tax)){
              $("#total_tax").html(tax.toFixed(2));}
              else
              {
              $("#total_tax").html(0.00);  
              }
            }
            else
            {
              $("#total_tax").html(0.00);
            }
              }
          }

          if (sub_total!=0)
           { 
             if (discount!= undefined)
             { 
             
              if (!isNaN(sub_total)){
                if (!isNaN(discount)){
                    var total_all= parseFloat(sub_total) -  parseFloat(discount)
                    
                    $("#total_quote").html(total_all.toFixed(2))
                  }
                  else
                  {  
                     $("#total_quote").html(sub_total.toFixed(2))
                  }
                    }
                if ((tax!=0) && (tax!=undefined))
                   {  
                    if (!isNaN(sub_total))
                    {
                      if (!isNaN(discount)){
                      var total_all= parseFloat(sub_total) -  parseFloat(discount) + parseFloat(tax)
                      $("#total_quote").html(total_all.toFixed(2))}
                    }
                  }
              }
            }
  }

var discount_null=$("#quote_discount_rate").val()
var tax_null=$("#quote_stripped_tax").val()
if ((discount_null== "") && (tax_null=="")){
  if (sub_total!=0){
   if (!isNaN(sub_total)){

    $("#total_quote").html(sub_total.toFixed(2))}
  }
}

if ((tax_null!="") && (discount_null=="")){
   if (sub_total!=0){
      var tax_calc=(parseFloat(sub_total)*parseFloat(tax_null))/100
      if (!isNaN(tax_calc)){
        $("#total_tax").html(tax_calc)
        var total_value_tax= tax_calc + sub_total
        $("#total_quote").html(total_value_tax.toFixed(2))
      }
    }
}
if (tax_null==""){
  $("#total_tax").html(0.00);}
 if ((discount_null==0.00) && (tax_null=="")){
   // $("#total_quote").html(sub_total.toFixed(2))
   $("#total_quote").html(sub_total.toFixed(2)).text("0.00")
 }


if (isNaN(tax_null)){
  if (discount_null==""){
    if (!isNaN(sub_total)){
    $("#total_quote").html(sub_total.toFixed(2))}
  }

}
}


function searchQuoteIndex(value){
  data=value
    if (!isNaN(data)){
      searchTable('#'+data);
    }
    else
    {
      searchTable(data);
    }
 

  function searchTable(inputVal)
  { var inputVal=inputVal.trim()
    var table = $('#tblData');
    var no_match=false;
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
        if(found == true){ no_match=false; $(row).show();}else {  no_match=true; $(row).hide();}
      }

    });
    if (no_match){$("#no_match").html("No match Found")}else{$("#no_match").html("")}
  }
 
 }




function searchClientQuoteModel(value){
  var data = value

  $.ajax({
          type: "POST",
          url: "/search_quote_client",
          data: {q: data}
         }); 
}

function sortByQuoteFirstLast(value){
   var data = value
    $.ajax({
    type: "POST",
    url: "/quote_sort",
    data: {sort_by: data}
   });
  }

  function sortByDraftArchive(value){
   var data = value
    $.ajax({
    type: "POST",
    url: "/quote_sort_archive",
    data: {sort_by: data}
   });
  }

function sortByQuoteTime(value){


   var data = value
    $.ajax({
    type: "POST",
    url: "/sort_by_time",
    data: {sort_by_month: data}
   });
  }
function ShowHide(){

 $('.sigPad').signaturePad({drawOnly:true});
$(".attach_files").click(function(){
  $("#attachment_field").show();
  $(".attach_files").hide();
  $(".cancel").show();
  $("#note_submit").show();
})

$(".cancel").click(function(){
  $("#attachment_field").hide();
  $("#inputattachment").val("")
  $(".cancel").hide();
  $("#note_submit").hide()
  $("#note").val("");

  $(".attach_files").show();
})
$("#note").focus(function(){
  $("#attachment_field").show();
  $(".attach_files").hide();
  $("#note_submit").show();
  $(".cancel").show();
})
}


function workValidation(){
  var i=0;
  var name=($(".work_name").val())
  $(".work_name").each(function(){
    var work_name = $(this).val();
    if (work_name==""){
      i++;
    }
  })
  if (i > 0){
    $("#work_result").text("Line items name must be set");
    $("#work_result").css("color", "red");
    return false;
  }
  else { return true;}
}


function submitQuote()
{
  $("[data-toggle=tooltip]").tooltip();
  $(".quote_create").click(function(){
    if (workValidation()){
      $('#new_quote').submit();}
  })
}