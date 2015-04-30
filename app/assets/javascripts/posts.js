$(document).ready(function(){
  if(location.href.indexOf("/posts/") != -1){
    var editor = ace.edit("editor");
    var keys = [];
    var preview = false;
    var confirm_send = 0;
    editor.setTheme("ace/theme/twilight");
    editor.getSession().setMode("ace/mode/markdown");
    editor.getSession().setUseWrapMode(true);
    editor.$blockScrolling = Infinity; // prevent browser message
    // editor.renderer.setShowGutter(false); // hide line number
    editor.renderer.setPadding(10);
    document.getElementById('editor').style.fontSize='14px';
    document.getElementById("title").focus();
    dismiss_message();
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
                "content": code
              }
            }).done(function(response){
              dismiss_message();
              location.href = "/posts/" + response.slug + "/edit";
            }).fail(function(response){
              $("#error").show();
              setTimeout(function(){ $("#error").delay(300).hide(); }, 1000);
            }).always(function(response){
              dismiss_message();
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
                "content": code
              }
            }).done(function(response){
              $("#success").show();
              setTimeout(function(){ $("#success").delay(300).hide(); }, 1000);

            }).fail(function(response){
              $("#error").show();
              setTimeout(function(){ $("#error").delay(300).hide(); }, 1000);
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

    function dismiss_message() {
      $("#pending").hide();
      $("#confirm").hide();
      $("#success").hide();
      $("#error").hide();
    };

    function display_pending() {
      $("#result").text("處理中...");
    }

    function print_result(text) {
      $("#result").text(text);
    }
  };
});

