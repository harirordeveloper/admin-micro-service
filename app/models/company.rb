class Company < ApplicationRecord
  include CompanySync

  has_many :employees
  has_many :admin_employees
end
