$(document).ready(function(){
  $("#categories-update").click(function(){
    // ids is declared in edit_categories.html.erb
    var hash = [];
    for(i=0;i<ids.length;i++){
      var id = ids[i];
      if($("#name-" + id).val() == ""){
        setTimeout(function(){ $("#blank").show(); }, 50);
        setTimeout(function(){ $("#blank").hide(); }, 1500);
        return;
      };
      hash.push({
        "id": id,
        "name": $("#name-" + id).val(),
        "slug": $("#slug-" + id).val()
      });
    };
    $("#pending").show();
    $.ajax({
      url: "/categories/update_all",
      type: "POST",
      data: {"categories": hash}
    // }).success(function(response){
    //   setTimeout(function(){ $("#success").show(); }, 50);
    //   setTimeout(function(){ $("#success").hide(); }, 1500);
    // }).error(function(response){
    //   setTimeout(function(){ $("#error").show(); }, 50);
    //   setTimeout(function(){ $("#error").hide(); }, 1500);
    }).always(function(response){
      dismiss_message();
      setTimeout(function(){ $("#success").show(); }, 50);
      setTimeout(function(){ $("#success").hide(); }, 1500);
    });
  });
});
