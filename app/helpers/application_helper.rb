module ApplicationHelper

  def is_admin?
    if current_user
      return current_user.is_admin?
    end
    false
  end

  def set(setting)
    @settings.find{|s|s["key"] == setting.to_s}["value"]
  end
end
