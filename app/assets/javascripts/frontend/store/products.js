$(document).ready(function(){
  var p_id;
  $(".add-to-cart").click(function(){
    p_id = $(this).attr("id").replace("p-","");
    token = $("meta[name='csrf-token']").attr("content");
    // $(".loadingScreen").show();
    // $.ajax({
    //   url: "/store/orders/" + p_id + "/add_to_cart",
    //   method: "POST",
    //   data: {'CSRFToken': token}
    // }).done(function(){
    //   location.reload();
      // console.log(response);
    // });
  });
});
