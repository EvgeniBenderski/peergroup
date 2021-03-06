require 'flash_messages'

class ApplicationController < ActionController::Base
  include FlashMessages
  include SessionsHelper

  protect_from_forgery

  before_filter :set_locale, :set_location
  before_filter :setup_title

  protected

  def set_locale
    # if params[:locale] is set to nil, then I18n.default_locale will be used
    I18n.locale = params[:locale]
  end

  def set_location
    is_sessions_controller = (controller_name == "sessions")
    is_new_user_action = (controller_name == "users" && action_name == "new")
    session[:return_to] = request.request_uri if request.get? && !is_sessions_controller && !is_new_user_action
  end

  def default_url_options
    { :locale => I18n.locale }
  end

  def setup_title
    @title = t("#{controller_name}.#{action_name}.title")
  end

  def require_parent_group
    @group = Group.find(params[:group_id])
  end

  def require_parent_supervision
    @supervision = Supervision.find(params[:supervision_id])
  end

  def self.require_supervision_state(*args)
    options = args.extract_options!
    filter_name = :"require_supervision_#{args.join("_or_")}_state"

    define_method filter_name do
      unless args.map(&:to_s).include?(@supervision.state)
        redirect_to supervision_path(@supervision)
        false
      end
    end

    before_filter filter_name, options
  end
end

