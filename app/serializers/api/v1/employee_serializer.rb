class Api::V1::EmployeeSerializer < ActiveModel::Serializer
  belongs_to :company, serializer: ::Api::V1::CompanySerializer
  attributes :id, :first_name, :last_name, :designation, :mobile, :address_line_1, :address_line_2, :gender, :dob, :email
end
