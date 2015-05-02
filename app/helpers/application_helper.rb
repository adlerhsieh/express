module ApplicationHelper
  def is_admin?
    if current_user
      return current_user.is_admin?
    end
    false
  end
end
