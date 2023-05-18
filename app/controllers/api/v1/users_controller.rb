class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user, :authorize_admin_user!, only: [:create]

  def create
    user = User.new(user_params)
    if user.save
      render_access_token(user.id, :created)
    else
      render_error user.errors.full_messages, :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end
end
