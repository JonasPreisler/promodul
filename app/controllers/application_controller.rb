class ApplicationController < ActionController::API
  require 'methods_service'
  include MethodsService
  before_action :validate_authentication
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end