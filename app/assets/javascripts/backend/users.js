$(document).ready(function(){
  if(location.pathname == "/users/adler"){
    $.ajax({
      url: "/bing_balance",
      type: "GET"
    }).done(function(response){
      $("#balance").text(response.balance);
      $("#usage").text(response.usage);
    });
  };
});
