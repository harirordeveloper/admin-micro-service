class Api::V1::CompaniesController < Api::V1::BaseController

  before_action :find_company, only: [:show, :update, :delete]

  def create
    company = Company.create!(company_params)
    KafkaService.send_message("company", { action: "create", resource: 'Company', service_id: 'admin_service', data: company.as_json })
    render json: company, status: :created
  end

  def update
    if @company.update(company_params)
      KafkaService.send_message("company", { action: "update", resource: 'Company', service_id: 'admin_service', data: company.as_json })
      render_resource @company, ::Api::V1::CompanySerializer, :ok
    else
      render_error @company.errors.full_messages, :unprocessable_entity
    end
  end

  def delete
    if @company.delete
      KafkaService.send_message("company", { action: "delete", resource: 'Company', service_id: 'admin_service', data: company.as_json })
      render_message "Successfully Deleted Company", :ok
    else
      render_error @company.errors.full_messages, :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :address_line_1, :address_line_2, :phone)
  end

  def find_company
    @company = Company.find_by_id(params[:id])
    render_error "No company found with the matching ID :: #{params[:id]}", :not_found
  end
end
