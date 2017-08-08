class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :null_session
  protect_from_forgery with: :exception
  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :load_settings
  before_action :clear_empty_order
  helper_method :current_order

  def current_order
    find_current_order
  end

  def find_current_order
    if session[:order_id]
      order = Store::Order.find_by_id(session[:order_id])
      if order
        if order.placed? || order.cart?
          return order
        else
          clear_current_cart
        end
      end
    end
  end

  def find_or_create_new_order
    if current_user && current_user.latest_order
      session[:order_id] = current_user.latest_order.id
      return current_user.latest_order 
    end
    order = Store::Order.create!
    order.update_column(:user_id, current_user.id) if current_user
    session[:order_id] = order.id
    return order
  end

  def clear_current_cart
    session[:order_id] = nil
  end

  def clear_empty_order
    session[:order_id] = nil unless current_order
  end

  def set_locale
  end

  def configure_devise_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(name email password password_confirmation))
    # devise_parameter_sanitizer.for(:sign_up) do |u|
    #   u.permit(:name, :email, :password, :password_confirmation)
    # end
  end

  def require_login
    redirect_to posts_path unless current_user
  end

  def require_admin
    if current_user
      if current_user.is_admin?
        return
      end
    end
    flash[:alert] = "路徑錯誤"
    redirect_to posts_path 
  end

  def is_admin?
    current_user.is_admin if current_user
  end

  def load_settings
    @settings = Setting.all.map(&:serializable_hash)
    return if params[:controller].index("store")
    if params[:action] == "show" && !(params[:controller].include? "users") && params[:controller] != "categories" && params[:format] != "json"
      # find record
      model = params[:controller].singularize.capitalize.constantize
      if model == Post
        record = model.includes(:category, :tags).find_by_slug(params[:id] || params[:slug])
      else
        record = model.includes(:category).find_by_slug(params[:id] || params[:slug])
      end
      if record
        # insert title
        title = record[:title] + " | "
        @settings.find{|s|s["key"] == "site_title"}["value"].insert(0,title)
        @settings.find{|s|s["key"] == "meta_title"}["value"].insert(0,title)
        @settings.find{|s|s["key"] == "og_title"}["value"].insert(0,title)
        # insert keywords
        if record.tags.size > 0
          keywords = record.tags.map(&:name).join(",") + ","
          @settings.find{|s|s["key"] == "meta_keywords"}["value"].insert(0,keywords)
        end
        @settings.find{|s|s["key"] == "meta_keywords"}["value"].insert(0,record.category.name+",")
        # insert description
      end
    end
  end
end
