class Api::V1::EmployeesController < ApplicationController
  def create
    employee = @company.employees.create!(employee_params)
    KafkaService.send_message("employee", { action: "create", company: employee.as_json })
    render json: employee, status: :created
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :is_admin, :designation, :mobile,  :address_line_1, :address_line_2, :gender, :dob)
  end

  def find_company
    @company = Company.find_by_id(id: params[:company_id])
    render json: "Company not found", status: :not_found if @company.blank?
  end
end
