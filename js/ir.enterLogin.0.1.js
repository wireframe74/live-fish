
$("form[name='logindetails'] input").keypress(function(event) {
    if (event.which == 13) {
        event.preventDefault();
        $("form[name='logindetails']").submit();
    }
});

$("form[name='accountdetails'] input").keypress(function(event) {
    if (event.which == 13) {
        event.preventDefault();
        $("form[name='accountdetails']").submit();
    }
});
