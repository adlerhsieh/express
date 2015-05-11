$(document).ready(function(){
  if(location.href.indexOf("/trainings") != -1){
    if(location.href.indexOf("/edit") != -1 || location.href.indexOf("/new") != -1){
      var editor;
      var keys;
      var preview;
      var confirm_send;
      var confirm_leave;
      var current_slug;
      var screencasts_list = false;
      var screencasts_selection = [];

      initialize_editor();
      $("#preview").hide();
      $("#list").hide();
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

        if(keys.indexOf(190) != -1 && keys.indexOf(91) != -1) {
          if(location.href.indexOf("/edit") != -1){
            keys.splice(keys.indexOf(190),1);
            if(screencasts_list == false){
              toggle_list(true);
              screencasts_list = true;
            }else{
              toggle_list(false);
              screencasts_list = false;
            };
          };
        };

        if(keys.indexOf(73) != -1 && keys.indexOf(91) != -1) {
          if(location.href.indexOf("/edit") != -1){
            keys.splice(keys.indexOf(73),1);
            $("#pending").show();
            var slug = $("#slug").val();
            $.ajax({
              url: "/users/" + current_user.name + "/trainings/" + current_slug + "/toggle_public",
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
            location.href = "/users/" + current_user.name + "/trainings";
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
            var skip = $("#skip").val();
            code = editor.session.getDocument().getAllLines();

            if(location.href.indexOf("/edit") == -1){
              $.ajax({
                url: "/users/" + current_user.name + "/trainings",
                type: "POST",
                data: {
                  "title": title,
                  "video_embed": video_embed,
                  "image_embed": image_embed,
                  "slug": slug,
                  "content": code,
                  "category": category,
                  "display_date": display_date,
                  "skip": skip
                }
              }).done(function(response){
                location.href = "/users/" + current_user.name + "/trainings/" + response.slug + "/edit";
              }).fail(function(response){
                dismiss_message();
                setTimeout(function(){ $("#error").show(); }, 50);
                setTimeout(function(){ $("#error").hide(); }, 1500);
              }).always(function(response){
              });
            }else{
              $.ajax({
                url: "/users/" + current_user.name + "/trainings/" + current_slug,
                type: "PUT",
                data: {
                  "title": title,
                  "video_embed": video_embed,
                  "image_embed": image_embed,
                  "slug": slug,
                  "content": code,
                  "category": category,
                  "display_date": display_date,
                  "skip": skip
                }
              }).done(function(response){
                if(response.slug == current_slug){
                  setTimeout(function(){ $("#success").show(); }, 50);
                  setTimeout(function(){ $("#success").hide(); }, 1500);
                }else{
                  location.href = "/users/" + current_user.name + "/trainings/" + response.slug + "/edit";
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
          $("#list").hide();
          $("#preview-content").html(response.post);
          $("#preview-title").html(post_title);
          if(video_tag.length < 1){
            $("#preview-video").hide();
            $("#preview-video").html(video_tag);
          }else{
            $("#preview-video").show();
          };
          $("#preview-image").html("<img class='preview_image' src='" + image_tag + "' />");
        });		    	
      };

      function toggle_edit() {
          // $("#editor").show();
          $(".editor-attr").show();
          $("#preview").hide();
          $("#list").hide();
          editor.focus();
          editor.gotoLine(current_row+1, current_column, true);
          editor.scrollToLine(current_row, true, true, function(){});
      };

      function toggle_public_tag() {
        
      };

      function toggle_list(value){
        if(value == true){
          // $("#editor").hide();
          $(".editor-attr").hide();
          $("#preview").hide();
          $("#list").show();
        }else{
          // $("#editor").show();
          $(".editor-attr").show();
          $("#preview").hide();
          $("#list").hide();
        };
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
          current_slug = location.href.replace(location.host,"").replace("http://","").replace("/trainings/","").replace("/edit","").replace("/users/","").replace(current_user.name, "");
          $.ajax({
            url: "/trainings/" + current_slug + ".json",
            type: "GET"
          }).done(function(response){
            $("#title").val(response.title);
            $("#video_embed").val(response.video_embed);
            $("#image_embed").val(response.image_embed);
            $("#category").val(response.category);
            $("#slug").val(response.slug);
            $("#display_date").val(response.display_date);
            $("#skip").val(response.skip);
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

angular.module("training", [])
.controller("editController", ['$scope','$http', function($scope,$http){
  $scope.confirm_save = 0;
  $scope.current_user = current_user;
  $scope.keys = [];
  current_slug = location.href.replace(location.host,"").replace("http://","").replace("/trainings/","").replace("/edit","").replace("/users/","").replace(current_user.name, "");
  $http.get("/users/" + current_user.name + "/trainings/" + current_slug + "/selections").success(function(response){
    $scope.selection = response;
  });
  $http.get("/users/" + current_user.name + "/trainings/" + current_slug + "/not_selected").success(function(response){
    $scope.list = response;
  });
  $scope.insert = function(item){
    index = $scope.list.indexOf(item);
    $scope.list.splice(index,1);
    $scope.selection.push(item);
    item.training_order = $scope.selection.indexOf(item);
  };
  $scope.remove = function(item){
    index = $scope.selection.indexOf(item);
    $scope.selection.splice(index,1);
    $scope.list.push(item);
  };
  $(document).keydown(function(key){
    $scope.keys.push(key.which);
    if($scope.keys.indexOf(13) != -1 && $scope.keys.indexOf(91) != -1) {
      $scope.confirm_save ++;
      $scope.keys.splice($scope.keys.indexOf(13),1);
      setTimeout(function(){
        $scope.confirm_save = 0;
      }, 1000);
      if($scope.confirm_save == 2){
        $scope.confirm_save = 0;
        $http({
          url: "/users/" + current_user.name + "/trainings/" + current_slug + "/update_selections",
          method: "POST",
          data: {"selected": $scope.selection},
          headers: {
                     'X-CSRF-Token': $("meta[name='csrf-token']").attr("content")
                   }
        }).success(function(response){
          
        });
      };
    };
  });
}]);
