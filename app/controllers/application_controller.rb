class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :restrict_unless_admin

  def restrict_unless_admin
    unless session[:admin]
      redirect_to root_path
    end
  end
end
