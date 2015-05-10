class IndexController < ApplicationController
  def index
    if params[:page_id]
      case params[:page_id].to_i
      when 2615
        redirect_to "/trainings/ae-basic-training"
      when 2531
        redirect_to "/categories/AfterEffects"
      end
    elsif params[:portfolio]
      case params[:portfolio]
      when "1-文字溶解"
        redirect_to "/blog/ae-text-dissolve-1"
      when "2-製作3d文字"
        redirect_to "/blog/ae-3d-text-1"
      when "3-開槍！"
        redirect_to "/blog/ae-fire"
      when "4-音樂視覺"
        redirect_to "/blog/ae-sound-animation"
      when "5-opengl算圖工具"
        redirect_to "/blog/ae-opengl"
      when "6-意識閃爍"
        redirect_to "/blog/ae-montage"
      when "7-ae中的2-5d空間"
        redirect_to "/blog/ae-25d"
      when "8-閃光標題"
        redirect_to "/blog/ae-beautiful-title"
      when "9-鎖定3D目標"
        redirect_to "/blog/ae-sure-target-1"
      when "10-基本時間控制"
        redirect_to "/blog/ae-time-control"
      when "11-修片＆改善色彩"
        redirect_to "/blog/ae-better-color"
      when "12-文字模組特效入門"
        redirect_to "/blog/ae-text-presets"
      when "13-焊接效果"
        redirect_to "/blog/ae-wielding"
      when "14-製作預設模組"
        redirect_to "/blog/ae-making-presets"
      when "15-鬼影幢幢"
        redirect_to "/blog/ae-ghost-title"
      when "16-彈跳效果"
        redirect_to "/blog/ae-bouncing-effect"
      end
    else
      redirect_to posts_path
    end
  end
end
