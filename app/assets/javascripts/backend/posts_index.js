$(document).ready(function(){
  var send = [];
  var id;
  var check;
  $(".email_send").click(function(){
    id = $(this).attr("data");
    check = "<span class='glyphicon glyphicon-ok' id='check_"+id+"'></span>"
    if(send.indexOf(id) == -1){
      send.push(id);
      $(this).prepend(check);
    }else{
      send.splice(send.indexOf(id), 1);
      $("#check_"+id).remove();
    };
  });
  $("button#confirm_send").click(function(){
    if(send.length > 0){
      $("button#confirm_send").text("發送中...");
      $("button#confirm_send").attr("disabled","disabled");
      $.ajax({
        method: "POST",
        url: "/users/send_post_email",
        data: {array: send}
      }).done(function(response){
        $("button#confirm_send").text("發送完成");
        alert(response);
        window.location.reload();
      }).fail(function(response){
        $("button#confirm_send").text("發送完成");
        alert("發送失敗，請檢查回傳訊息");
      });
    };
  });
});
