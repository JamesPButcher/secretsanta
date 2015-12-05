class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :restrict_unless_admin

  def self.user_password
    Rails.env.test? ? 'password' : ENV['USER_PASSWORD']
  end

  http_basic_authenticate_with name: "xmas", password: user_password, if: :need_http_auth?

  def restrict_unless_admin
    unless session[:admin]
      redirect_to root_path
    end
  end

  private

  def need_http_auth?
    return false if request.env['HTTP_AUTHORIZATION']
    return false if session[:using_valid_token]

    !access_token_used_and_valid?
  end

  def access_token_used_and_valid?
    return true if session[:using_valid_token]
    result = (params[:access_token] == (Rails.env.test? ? 'access_token' : ENV['USER_TOKEN']))
    session[:using_valid_token] = result
  end
end
