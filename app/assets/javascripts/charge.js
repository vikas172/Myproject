function stripeTokenGenerateTest(){
	$(document).ready(function() {
   Stripe.setPublishableKey('pk_test_lyYYz5ObfjV7rWasjyxGjIHm');
	  $("#stripe_button_submit").click(function() {
	    $('#stripe_button_submit').attr("disabled", "disabled");

	    Stripe.createToken({
	        number: $('#billing_info_card_number').val(),
	        cvc: $('#billing_info_ccv').val(),
	        exp_month: $('#charge_exp_month').val(),
	        exp_year: $('#charge_exp_year').val()
	    }, stripeResponseHandler);
	    // prevent the form from submitting with the default action
	    return false;
	  });
  });

	function stripeResponseHandler(status, response) {

    if (response.error) {
    		$(".payment-errors").css('display', 'block');
        $(".payment-errors").text(response.error.message);
    } 
    else {
        var form$ = $("#stripe-form");
        var token = response['id'];
        form$.append("<input type='hidden' name='stripeToken' value='" + token + "'/>");
        form$.get(0).submit();
    }
  }
}

function paymentReceipt(id,charge_id){
   $.ajax({
        type: "GET",
        url: "/charges/"+id+"/view_receipt",
        data: {data: charge_id}
       });
}
