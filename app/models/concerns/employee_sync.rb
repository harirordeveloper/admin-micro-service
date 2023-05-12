module EmployeeSync
  extend ActiveSupport::Concern

  module ClassMethods
    def sync_data(message)
      action = message[:action]
      data = message[:data].with_indifferent_access
      case action
      when 'create'
        create_employee data
      when 'update'
        update_employee data
      when 'delete'
        delete_employee data
      end
    end

    def create_employee employee_attr
      employee = create(employee_attr)
      Rails.logger.info("Created employee #{employee.id }")
    end

    def update_employee employee_attr
      employee = find_by_id(employee_attr[:id])
      employee.update(employee_attr) if employee.present?
      Rails.logger.info("Update employee #{employee.id }")
    end

    def delete_employee employee_attr
      employee = find_by_id(employee_attr[:id])
      employee.delete if employee.present?
      Rails.logger.info("Deleted employee #{employee.id }")
    end
  end
end
