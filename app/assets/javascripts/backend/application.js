//= require angular
//= require jquery_ujs
//= require dropdown
//= require_tree .
//= require ace
//= require theme-twilight
//= require mode-markdown
//= require highlight
//= require bootstrap

function dismiss_message() {
  $(".message").hide();
};

$(document).ready(function(){
  if($(window).width() < 992){
    $(".pull-right").removeClass("pull-right");
    $(".product").css("width",null);
  };
});
