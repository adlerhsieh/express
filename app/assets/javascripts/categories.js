$(document).ready(function(){
  $("#categories-update").click(function(){
    // ids is declared in edit_categories.html.erb
    var hash = [];
    for(i=0;i<ids.length;i++){
      var id = ids[i];
      hash.push({
        "id": id,
        "name": $("#name-" + id).val(),
        "slug": $("#slug-" + id).val()
      });
    };
    $.ajax({
      url: "/categories/update_all",
      type: "POST",
      data: {"categories": hash}
    }).done(function(response){

    });
  });
});
