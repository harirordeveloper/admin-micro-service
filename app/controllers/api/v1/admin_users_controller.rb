class Api::V1::AdminUsersController < Api::V1::BaseController
  def create
    admin_user = AdminUser.create!(admin_user_params)
    KafkaService.send_message("admin_user", { action: "create", resource: 'company', data: admin_user.as_json })
    render json: admin_user, status: :created
  end

  private

  def admin_user_params
    params.require(:admin_user).permit(:first_name, :last_name, :email, :mobile, :address_line_1, :address_line_2, :gender, :dob)
  end
end
