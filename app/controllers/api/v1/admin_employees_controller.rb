class Api::V1::AdminEmployeesController < Api::V1::EmployeesController

  def index
    @employees = AdminEmployee.search(
      params[:query],
      fields: [:first_name, :last_name, :email],
      match: :word_start,
      highlight: { tag: '<em>' }
    )
    render_resource @employees, ::Api::V1::EmployeeSerializer, :ok, true
  end

  def create
    employee = @company.admin_employees.create!(employee_params)
    KafkaService.send_message("admin_employee", { action: "create", resource: 'AdminEmployee', service_id: 'admin_service', data: @employee.as_json })
    render json: employee, status: :created
  end

  def update
    if @employee.update(employee_params)
      KafkaService.send_message("admin_employee", { action: "update", resource: 'AdminEmployee', service_id: 'admin_service', data: @employee.as_json })
      render_resource @employee, ::Api::V1::EmployeeSerializer, :ok
    else
      render_error @employee.errors.full_messages, :unprocessable_entity
    end
  end

  def delete
    if @employee.delete
      KafkaService.send_message("admin_employee", { action: "delete", resource: 'AdminEmployee', service_id: 'admin_service', data: @employee.as_json })
      render_message "Successfully Deleted Employee", :ok
    else
      render_error @employee.errors.full_messages, :unprocessable_entity
    end
  end

  private

    def find_employee
      @employee = AdminEmployee.find_by_id(id: params[:id])
      render json: "Admin Employee not found", status: :not_found if @employee.blank?
    end
end
