class Api::V1::CompaniesController < ApplicationController
  def create
    company = Company.create!(company_params)
    KafkaService.send_message("company", { action: "create", company: company.as_json })
    render json: company, status: :created
  end

  private

  def company_params
    params.require(:company).permit(:name, :address_line_1, :address_line_2, :phone)
  end
end
