$(document).ready(function(){
  if(location.href.indexOf("/posts/") != -1){
    var editor = ace.edit("editor");
    var keys = [];
    var preview = false;
    editor.setTheme("ace/theme/twilight");
    editor.getSession().setMode("ace/mode/markdown");
    editor.getSession().setUseWrapMode(true);
    editor.$blockScrolling = Infinity; // prevent browser message
    // editor.renderer.setShowGutter(false); // hide line number
    editor.renderer.setPadding(10);
    document.getElementById('editor').style.fontSize='14px';
    document.getElementById("title").focus();
    $("#pending").hide();
    $("#preview").hide();

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
        if(preview == false){
          toggle_preview();
          preview = true;
        }else{
          toggle_edit();
          preview = false;
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
      $("#pending").show().animate({opacity:1},100);

      $.ajax({
        url: "/posts/render_markdown",
        type: "POST",
        data: { "post": code }
      }).done(function(response){
        // $("#pending").hide();
        $("#pending").animate({opacity:0},0).hide();
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

    function display_pending() {
      $("#result").text("處理中...");
    }

    function print_result(text) {
      $("#result").text(text);
    }
  };
});

