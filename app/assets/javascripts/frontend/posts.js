$(document).ready(function(){
  resize_video();
  $(window).resize(function(){
    resize_video();
  });
  function resize_video() {
    if($("#preview-video").length > 0){
      var container = $("#preview-video");
    }else{
      var container = $(".screencast");
    };
    width = parseInt(container.css("width"));
    container.css("height", parseInt(width/16*10).toString()+"px");
  };
});
