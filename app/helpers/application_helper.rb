module ApplicationHelper

  def is_admin?
  	session[:admin]
  end
end
