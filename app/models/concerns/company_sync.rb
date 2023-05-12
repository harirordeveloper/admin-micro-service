module CompanySync
  extend ActiveSupport::Concern

  module ClassMethods
    def sync_data(message)
      action = message[:action]
      data = message[:data].with_indifferent_access
      case action
      when 'create'
        create_company data
      when 'update'
        update_company data
      when 'delete'
        delete_company data
      end
    end

    def create_company company_attr
      company = create(company_attr)
      Rails.logger.info("Created Company #{company.id }")
    end

    def update_company company_attr
      company = find_by_id(company_attr[:id])
      company.update(company_attr) if company.present?
      Rails.logger.info("Update Company #{company.id }")
    end

    def delete_company company_attr
      company = find_by_id(company_attr[:id])
      company.delete if company.present?
      Rails.logger.info("Deleted Company #{company.id }")
    end
  end
end
