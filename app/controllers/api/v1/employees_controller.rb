class Api::V1::EmployeesController < Api::V1::BaseController

  before_action :find_company, only: :create
  before_action :find_employee, only: [:update, :delete, :show]

  def index
    @employees = Employee.search(
      params[:query],
      fields: [:first_name, :last_name, :email],
      match: :word_start,
      highlight: { tag: '<em>' }
    )
    # render json: @employees, root: 'employees', adapter: :json, each_serializer: ::Api::V1::EmployeeSerializer,  status: :ok
    render_resource @employees, ::Api::V1::EmployeeSerializer, :ok, true
  end

  def create
    employee = @company.employees.create!(employee_params)
    KafkaService.send_message("employee", { action: "create", resource: 'Employee', service_id: 'admin_service', data: employee.as_json })
    render json: employee, status: :created
  end

  def update
    if @employee.update(employee_params)
      @employee.reload
      KafkaService.send_message("employee", { action: "update", resource: 'Employee', service_id: 'admin_service', data: @employee.as_json })
      render_resource @employee, ::Api::V1::EmployeeSerializer, :ok
    else
      render_error @employee.errors.full_messages, :unprocessable_entity
    end
  end

  def delete
    if @employee.delete
      KafkaService.send_message("employee", { action: "delete", resource: 'Employee', service_id: 'admin_service', data: @employee.as_json })
      render_message "Successfully Deleted Employee", :ok
    else
      render_error @employee.errors.full_messages, :unprocessable_entity
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :is_admin, :designation, :mobile,  :address_line_1, :address_line_2, :gender, :dob, :email, :password)
  end

  def find_company
    @company = Company.find_by_id(params[:company_id])
    render json: "Company not found", status: :not_found if @company.blank?
  end

  def find_employee
    @employee = Employee.find_by_id(params[:id])
    render json: "Employee not found", status: :not_found if @employee.blank?
  end
end
