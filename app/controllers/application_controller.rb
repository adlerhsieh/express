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
    @current_order ||= Store::Order.find_by_id(session[:order_id])
  end

  def find_current_order
    if current_order
      current_order
    elsif current_user
      cart = current_user.cart
      session[:order_id] = cart.id if cart.aasm_state == "cart"
      return cart
    else
      cart = Store::Order.create!
      session[:order_id] = cart.id
      return cart
    end
  end

  def clear_empty_order
    session[:order_id] = nil unless current_order
  end

  def set_locale
    # available_languages = ["zh-TW", "zh-HK", "zh-CN"]
    # zh_trad = ["zh-TW", "zh-HK"]
    # lang = http_accept_language.preferred_language_from(available_languages)
    # if zh_trad.include? lang
    #   I18n.locale = :"zh-TW"
    # else
    #   I18n.locale = :"zh-CN"
    # end
    # I18n.locale = :"zh-CN"
  end

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
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
    redirect_to sign_in_path 
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
        # unless record.content.nil? || record.content.length < 10
        #   description = record.content[0..250]
        #   unless record.content.index("!").nil?
        #     if record.content.index("!") < 10
              # index_new_line = record.content[1..-1].index("\n")
              # description = record.content[index_new_line..index_new_line + 250]
            # end
          # end
          # @settings.find{|s|s["key"] == "meta_description"}["value"] = description
          # @settings.find{|s|s["key"] == "og_description"}["value"] = description
        # end
      end
    end
  end
end
