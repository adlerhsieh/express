$(document).ready(function(){
  if(location.href.indexOf("/screen_casts") != -1){
    if(location.href.indexOf("/edit") != -1 || location.href.indexOf("/new") != -1){
      var editor;
      var keys;
      var preview;
      var confirm_send;
      var confirm_leave;
      var current_slug;

      initialize_editor();
      $("#preview").hide();
      initialize_content();
      get_category_list();

      $(document).keydown(function(key){
        keys.push(key.which);
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
            var slug = $("#slug").val();
            $.ajax({
              url: "/users/" + current_user.name + "/screen_casts/" + current_slug + "/toggle_public",
              type: "POST",
              data: {
                "slug": slug,
                "toggle_public": true
              }
            }).done(function(response){
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
            location.href = "/users/" + current_user.name + "/screen_casts";
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
            var video_embed = $("#video_embed").val();
            var image_embed = $("#image_embed").val();
            var slug = $("#slug").val();
            var display_date = $("#display_date").val();
            code = editor.session.getDocument().getAllLines();

            if(location.href.indexOf("/edit") == -1){
              $.ajax({
                url: "/users/" + current_user.name + "/screen_casts",
                type: "POST",
                data: {
                  "title": title,
                  "video_embed": video_embed,
                  "image_embed": image_embed,
                  "slug": slug,
                  "content": code,
                  "category": category,
                  "display_date": display_date
                }
              }).done(function(response){
                location.href = "/users/" + current_user.name + "/screen_casts/" + response.slug + "/edit";
              }).fail(function(response){
                dismiss_message();
                setTimeout(function(){ $("#error").show(); }, 50);
                setTimeout(function(){ $("#error").hide(); }, 1500);
              }).always(function(response){
              });
            }else{
              $.ajax({
                url: "/users/" + current_user.name + "/screen_casts/" + current_slug,
                type: "PUT",
                data: {
                  "title": title,
                  "video_embed": video_embed,
                  "image_embed": image_embed,
                  "slug": slug,
                  "content": code,
                  "category": category,
                  "display_date": display_date
                }
              }).done(function(response){
                if(response.slug == current_slug){
                  setTimeout(function(){ $("#success").show(); }, 50);
                  setTimeout(function(){ $("#success").hide(); }, 1500);
                }else{
                  location.href = "/users/" + current_user.name + "/screen_casts/" + response.slug + "/edit";
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
        var video_tag = $('#video_embed').val();
        var image_tag = $('#image_embed').val();
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
          $("#preview-video").html(video_tag);
          $("#preview-image").html("<img class='preview_image' src='" + image_tag + "' />");
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

      function initialize_editor() {
        editor = ace.edit("editor");
        keys = [];
        preview = false;
        confirm_send = 0;
        confirm_leave = 0;
        editor.setTheme("ace/theme/twilight");
        editor.getSession().setMode("ace/mode/markdown");
        editor.getSession().setUseWrapMode(true);
        editor.$blockScrolling = Infinity; // prevent browser message
        // editor.renderer.setShowGutter(false); // hide line number
        editor.renderer.setPadding(10);
        document.getElementById('editor').style.fontSize='14px';
        document.getElementById("title").focus();
      };

      function initialize_content(){
        if(location.href.indexOf("/edit") != -1){
          current_slug = location.href.replace(location.host,"").replace("http://","").replace("/screen_casts/","").replace("/edit","").replace("/users/","").replace(current_user.name, "");
          $.ajax({
            url: "/screen_casts/" + current_slug + ".json",
            type: "GET"
          }).done(function(response){
            $("#title").val(response.title);
            $("#video_embed").val(response.video_embed);
            $("#image_embed").val(response.image_embed);
            $("#category").val(response.category);
            $("#slug").val(response.slug);
            $("#display_date").val(response.display_date);
            if(response.is_public == true){
              $("#is_public").css("display", "inline");
            }else{
              $("#is_not_public").css("display", "inline");
            };
            editor.setValue(response.content);
            editor.gotoLine(1, current_column, true);
            editor.scrollToLine(1, true, true, function(){});
          });
        };
      };

      function get_category_list(){
        $.ajax({
          url: "/categories",
          type: "GET"
        }).done(function(response){
          $("#category").autocomplete({
            source: response.categories
          });
        });
      };

    };
  };
});

