$(document).ready(function(){
  $("#open-ship").click(function(){
    $(this).hide();
    $("#ship-col").show();
    $("html,body").animate({
      scrollTop: $("#ship-col").offset().top
    },300);
  });
});
