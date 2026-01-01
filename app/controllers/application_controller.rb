class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  allow_browser versions: :modern

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || home_index_path)
  end

  def after_sign_in_path_for(resource)
    home_index_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
