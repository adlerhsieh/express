$(document).ready(function(){
  var p_id;
  $(".add-to-cart").click(function(){
    p_id = $(this).attr("id").replace("p-","");
    token = $("meta[name='csrf-token']").attr("content");
  });
});
