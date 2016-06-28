function job_repeat(){
	$('#repeat_frequency').on("change", function(){
		if($('#repeat_frequency').val() == "Weekly"){
			$('.daily_options').css('display', 'none')
			$('.weekly_options').css('display', 'block')
			$('.monthly_options').css('display', 'none')
			$('.yearly_options').css('display', 'none')
			$("#sum_daily").html("Summary: Weekly");
		}else if($('#repeat_frequency').val() == "Daily"){
			$('.daily_options').css('display', 'block')
			$('.weekly_options').css('display', 'none')
			$('.monthly_options').css('display', 'none')
			$('.yearly_options').css('display', 'none')
			$("#sum_daily").html("Summary: Daily");

		}else if($('#repeat_frequency').val() == "Monthly"){
			$('.daily_options').css('display', 'none')
			$('.weekly_options').css('display', 'none')
			$('.monthly_options').css('display', 'block')
			$('.yearly_options').css('display', 'none')
			$("#sum_daily").html("Summary: Monthly");
		}else if($('#repeat_frequency').val() == "Yearly"){
			$('.daily_options').css('display', 'none')
			$('.weekly_options').css('display', 'none')
			$('.monthly_options').css('display', 'none')
			$('.yearly_options').css('display', 'block')
			$("#sum_daily").html("Summary: Yearly");
		}
	})
	$('.monthly_rule_type_day').on("click", function(){
		$('.rs_calendar_day').css('display', 'block');
		$('.rs_calendar_week').css('display', 'none');
	})
	$('.monthly_rule_type_week').on('click', function(){
		$('.rs_calendar_day').css('display', 'none');
		$('.rs_calendar_week').css('display', 'block');
	})
	$('.day_holder a').on('click', function(){
		$('.rs_dialog a').each(function (event) {
		  $(this).removeAttr("class","selected")
		  // or use return false;
		});
		var day = $(this).data('value')
		$('#day_holder_').val(day)
		$(this).toggleClass('selected');
	})
	$('.rs_calendar_day a').on('click', function(){
		$('.rs_dialog a').each(function (event) {
		  $(this).removeAttr("class","selected")
		  // or use return false;
		});
		var day = $(this).data('value')
		$('#repeat_calender_day').val(day)
		$(this).toggleClass('selected');
	})
	$('.rs_calendar_week a').on('click', function(){
		$('.rs_dialog a').each(function (event) {
		  $(this).removeAttr("class","selected")
		  // or use return false;
		});
		var day = $(this).attr('value')
		$('#repeat_calendar_week').val(day)
		$(this).toggleClass('selected');
	})

	$('#repeat_job_save').click(function(){
		$('.repeat-create').submit();
	})


	$("#repeat_daily_interval").change(function(){
		var daily_interval = $("#repeat_daily_interval").val();
		if (daily_interval!="")
		  {
		    $("#sum_daily").html("Summary: "+daily_interval+" days");
		  }
		else
		{
			$("#sum_daily").html("Summary: Daily");
		}
	})
}