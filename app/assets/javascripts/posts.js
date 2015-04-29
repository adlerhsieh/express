$(document).ready(function(){
  var editor = ace.edit("editor");
  var keys = {};
  var preview = false;
  editor.setTheme("ace/theme/twilight");
  editor.getSession().setMode("ace/mode/markdown");
  editor.getSession().setUseWrapMode(true);
  editor.$blockScrolling = Infinity; // prevent browser message
  editor.renderer.setShowGutter(false); // hide line number
  editor.renderer.setPadding(10);
  document.getElementById('editor').style.fontSize='14px';
  document.getElementById("title").focus();

    $("#send").click(function(){

    });

	$(document).keydown(function(key){
		keys[key.which] = true;
		if(keys.hasOwnProperty(75) == true && keys.hasOwnProperty(91) == true) {
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
      console.log(keys);
    	delete keys[key.which];
    });

  function toggle_preview() {
    code = editor.session.getDocument().getAllLines();
    $.ajax({
    	url: "/posts/render_markdown",
    	type: "POST",
    	data: { "post": code }
    }).done(function(response){
    	keys = {};
      $("#editor").hide();
      $("#preview").show();
      $("#preview").html(response.post);
    });		    	
  };

  function toggle_edit() {
      $("#editor").show();
      $("#preview").hide();
  };

});


function display_pending() {
	$("#result").text("處理中...");
}

function print_result(text) {
	$("#result").text(text);
}
