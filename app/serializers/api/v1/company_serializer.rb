class Api::V1::CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :address_line_1, :address_line_2, :phone
end
