var use_default_tab = true;

$(document).ready(function(){
  if(location.href.indexOf("users") != -1){
    tab_switch("edit_posts");
    tab_switch("edit_categories");
    default_tab();
  };
});

function tab_switch(tab) {
  if(location.href.indexOf(tab) != -1){
    $("#" + tab).addClass("active");
    use_default_tab = false;
  };
};

function default_tab() {
  if(use_default_tab == true){
    $("#basic_info").addClass("active");
  };
};
