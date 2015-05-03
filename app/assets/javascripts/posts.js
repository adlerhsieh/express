$(document).ready(function(){
  if(location.href.indexOf("/posts/") != -1){
    var editor = ace.edit("editor");
    var keys = [];
    var preview = false;
    var confirm_send = 0;
    var confirm_leave = 0;
    editor.setTheme("ace/theme/twilight");
    editor.getSession().setMode("ace/mode/markdown");
    editor.getSession().setUseWrapMode(true);
    editor.$blockScrolling = Infinity; // prevent browser message
    // editor.renderer.setShowGutter(false); // hide line number
    editor.renderer.setPadding(10);
    document.getElementById('editor').style.fontSize='14px';
    document.getElementById("title").focus();
    $("#preview").hide();
    if(location.href.indexOf("/edit") != -1){
      current_slug = location.href.replace(location.host,"").replace("http://","").replace("/posts/","").replace("/edit","");
      $.ajax({
        url: "/blog/" + current_slug + ".json",
        type: "GET"
      }).done(function(response){
        $("#title").val(response.post.title);
        $("#category").val(response.category.name);
        $("#slug").val(response.post.slug);
        $("#tags").val(response.tags);
        $("#display_date").val(response.post.display_date);
        if(response.post.is_public == true){
          $("#is_public").css("display", "inline");
        }else{
          $("#is_not_public").css("display", "inline");
        };
        editor.setValue(response.post.content);
        editor.gotoLine(1, current_column, true);
        editor.scrollToLine(1, true, true, function(){});
      });
    };

    $.ajax({
      url: "/categories",
      type: "GET"
    }).done(function(response){
      $("#category").autocomplete({
        source: response.categories
      });
    });


    $("#send").click(function(){

    });

    $(document).keydown(function(key){
      keys.push(key.which);
      // console.log(keys);
      if(keys.indexOf(75) != -1 && keys.indexOf(91) != -1) {
        keys.splice(keys.indexOf(75),1);
        if(preview == false){
          toggle_preview();
          preview = true;
        }else{
          toggle_edit();
          preview = false;
        };
      };

      if(keys.indexOf(73) != -1 && keys.indexOf(91) != -1) {
        if(location.href.indexOf("/edit") != -1){
          keys.splice(keys.indexOf(73),1);
          $("#pending").show();
          var title = $("#title").val();
          var category = $("#category").val();
          var tags = $("#tags").val();
          var slug = $("#slug").val();
          var display_date = $("#display_date").val();
          code = editor.session.getDocument().getAllLines();
          $.ajax({
            url: "/posts/" + current_slug,
            type: "PUT",
            data: {
              "title": title,
              "category": category,
              "tags": tags,
              "slug": slug,
              "content": code,
              "display_date": display_date,
              "toggle_public": true
            }
          }).done(function(response){
            $("#success").show();
            setTimeout(function(){ $("#success").show(); }, 50);
            setTimeout(function(){ $("#success").hide(); }, 1500);
            if(response.is_public == true){
              $("#is_public").css("display", "inline");
              $("#is_not_public").css("display", "none");
            }else{
              $("#is_public").css("display", "none");
              $("#is_not_public").css("display", "inline");
            };
          }).fail(function(response){
            setTimeout(function(){ $("#error").show(); }, 50);
            setTimeout(function(){ $("#error").hide(); }, 1500);
          }).always(function(response){
            // $("#pending").hide();
            dismiss_message();
          });
        };
      };

      if(keys.indexOf(74) != -1 && keys.indexOf(91) != -1) {
        confirm_leave ++;
        keys.splice(keys.indexOf(74),1);
        $("#leave").show();
        setTimeout(function(){
          $("#leave").delay(300).hide();
          confirm_leave = 0;
        }, 1000);
        if(confirm_leave == 2){
          dismiss_message();
          location.href = "/users/" + current_user.name + "/edit_posts";
        };
      };

      if(keys.indexOf(13) != -1 && keys.indexOf(91) != -1) {
        confirm_send ++;
        keys.splice(keys.indexOf(13),1);
        $("#confirm").show();
        setTimeout(function(){
          $("#confirm").delay(300).hide();
          confirm_send = 0;
        }, 1000);
        if(confirm_send == 2){
          confirm_send = 0;
          dismiss_message();
          $("#pending").show();
          var title = $("#title").val();
          var category = $("#category").val();
          var tags = $("#tags").val();
          var slug = $("#slug").val();
          var display_date = $("#display_date").val();
          code = editor.session.getDocument().getAllLines();

          if(location.href.indexOf("/edit") == -1){
            $.ajax({
              url: "/posts",
              type: "POST",
              data: {
                "title": title,
                "category": category,
                "tags": tags,
                "slug": slug,
                "content": code,
                "display_date": display_date
              }
            }).done(function(response){
              location.href = "/posts/" + response.slug + "/edit";
            }).fail(function(response){
              dismiss_message();
              setTimeout(function(){ $("#error").show(); }, 50);
              setTimeout(function(){ $("#error").hide(); }, 1500);
            }).always(function(response){
            });
          }else{
            $.ajax({
              url: "/posts/" + current_slug,
              type: "PUT",
              data: {
                "title": title,
                "category": category,
                "tags": tags,
                "slug": slug,
                "content": code,
                "display_date": display_date
              }
            }).done(function(response){
              $("#success").show();
              setTimeout(function(){ $("#success").show(); }, 50);
              setTimeout(function(){ $("#success").hide(); }, 1500);
            }).fail(function(response){
              setTimeout(function(){ $("#error").show(); }, 50);
              setTimeout(function(){ $("#error").hide(); }, 1500);
            }).always(function(response){
              // $("#pending").hide();
              dismiss_message();
            });
          };
        };
      };
    });

      $(document).keyup(function(key){
        keys = [];
      });


    var current_row = 0;
    var current_column = 0;
    function toggle_preview() {
      code = editor.session.getDocument().getAllLines();
      var current_position = editor.selection.getCursor();
      current_row = current_position.row;
      current_column = current_position.column;
      var post_title = $('#title').val();
      var post_category = $('#category').val();
      var post_tags = $('#tags').val();
      $("#pending").show();

      $.ajax({
        url: "/posts/render_markdown",
        type: "POST",
        data: { "post": code }
      }).done(function(response){
        dismiss_message();
        $(".editor-attr").hide();
        $("#preview").show();
        $("#preview-content").html(response.post);
        $("#preview-title").html(post_title);
        $("#preview-category").html(post_category);
        $("#preview-tags").html(post_tags);
      });		    	
    };

    function toggle_edit() {
        // $("#editor").show();
        $(".editor-attr").show();
        $("#preview").hide();
        editor.focus();
        editor.gotoLine(current_row+1, current_column, true);
        editor.scrollToLine(current_row, true, true, function(){});
    };

    function toggle_public_tag() {
      
    };

  };
});

