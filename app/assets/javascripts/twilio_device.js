
var connection;

    Twilio.Device.ready(function (device) {
        $("#twilio_call_log").text("Ready");
    });

    Twilio.Device.error(function (error) {
        $("#twilio_call_log").text("Error: " + error.message);
    });

    Twilio.Device.connect(function (conn) {
     
        $("#twilio_call_log").text("Successfully established call");
        connection = conn;
    });

    Twilio.Device.disconnect(function (conn) {
    $("#twilio_call_log").text("Call ended");
    });


function hangup() {
    Twilio.Device.disconnectAll();
}

function senddigits(i) {
    if (connection!=null)
        connection.sendDigits(i);
}