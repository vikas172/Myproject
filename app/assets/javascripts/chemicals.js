function searchClientChemicalModel(value){
  var data = value
  $.ajax({
    type: "POST",
    url: "/search_client",
    data: {q: data}
  }); 
}

function add_chemicals_info(){
    var j = $('#chemicals li').length-1;
    var a = ('<li style="padding: 0px 30px 0px 0px;"><select id="chemical_chemicals_'+j+'_name" name="chemical[chemicals]['+j+'][name]"><option value="">Set Later</option></select> <input id="chemical_chemicals_'+j+'_concentration_" name="chemical[chemicals]['+j+'][concentration][]" type="text" value="">  <a class="circle_icon minus_icon start_grey" href="#" onclick="$(this).parent().remove();; return false;">-</a></li>');
    $(a).appendTo("#chemicals");
  }

function add_chemicals(){
  var j = $('#chemicals li').length-1;
  var a = ("<li><input id='chemical_treatment_settings_chemicals_"+j+"_name' name='chemical_treatment_settings[chemicals]["+j+"][name]' type='text' />  <input id='chemical_treatment_settings_chemicals_"+j+"_reg_no' name='chemical_treatment_settings[chemicals]["+j+"][reg_no]' type='text' />  <input id='chemical_treatment_settings_chemicals_"+j+"_default_pest' name='chemical_treatment_settings[chemicals]["+j+"][default_pest]' type='text' />  <a class='cancel' href='#' onclick='$(this).parent().remove();; return false;'>Remove</a></li>")
  $(a).appendTo("#chemicals");
}

function add_mixture(){
    var j = $('#chemicals li').length-1;
    var a = ('<li><select id="chemical_treatment_mixture_chemicals_'+j+'_name" name="chemical_treatment_mixture[chemicals]['+j+'][name]"><option value="a">A</option><option value="b">B</option></select> <input id="chemical_treatment_mixture_chemicals_'+j+'_concentration" name="chemical_treatment_mixture[chemicals]['+j+'][concentration]" type="text"> <a class="cancel" href="#" onclick="$(this).parent().remove();; return false;">Remove</a></li>');
    $(a).appendTo("#chemicals");
  }