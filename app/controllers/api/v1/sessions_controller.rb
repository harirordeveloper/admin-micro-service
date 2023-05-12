class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user, :authorize_admin_user!, only: [:create]

  def create
    user = AdminUser.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render_access_token(user.id, :ok)
    else
      render_error 'Invalid email or password', :unprocessable_entity
    end
  end

  def destroy
    if current_user.present?
      current_user.revoke_jwt
      render json: { message: "Logedout Successfully!" }, status: :ok
    else
      render_error 'No Active session for this user!', :unauthorized
    end
  end
end