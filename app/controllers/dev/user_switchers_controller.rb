module Dev
  class UserSwitchersController < ApplicationController
    # Skip pundit checking for this dev tool
    skip_after_action :verify_authorized, only: [ :create ], raise: false
    skip_after_action :verify_policy_scoped, only: [ :create ], raise: false

    def create
      unless Rails.env.development? || Rails.env.test?
        return head :forbidden
      end

      target_user = User.find(params[:user_id])

      # Devise method to cleanly log out current session & log in new record
      sign_out(current_user) if current_user
      sign_in(:user, target_user)

      flash[:notice] = "Switched identity to #{target_user.full_name} #{target_user.role.present? ? "(#{target_user.role.upcase})" : ""}."
      redirect_to dashboard_home_path
    end
  end
end
