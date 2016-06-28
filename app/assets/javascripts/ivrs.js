//data table initializations
$(document).ready(function(){
    $("#call_logs_table").dataTable({
    });
});

//data table initializations
$(document).ready(function(){
    $("#analytics_table").dataTable({
    });
});

$(document).ready(function(){
    $("#countries_table").dataTable({
        "aLengthMenu": [[5, 10, -1], [5, 10, "All"]] ,
        'iDisplayLength': 5
    });
});
$(document).ready(function(){
    $("#email_scraper_table").dataTable({
    });
});

$(document).ready(function(){
    $("#numbers_table").dataTable({
        "aLengthMenu": [[5, 10, -1], [5, 10, "All"]] ,
        'iDisplayLength': 5
    });
});

$(document).ready(function(){
    $('#dp5').fdatepicker()
});

$(document).ready(function(){
    $('#dp6').fdatepicker()
});