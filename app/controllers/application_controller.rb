class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale, :set_jid
  
  rescue_from CanCan::AccessDenied do |exception|
    p current_user
    redirect_to root_url, :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :pseudo << :xmpp_password
    devise_parameter_sanitizer.for(:sign_in) << :pseudo
    devise_parameter_sanitizer.for(:account_update) << :pseudo
  end
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  def set_jid
    @jid = current_user.jid if user_signed_in?
  end
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
