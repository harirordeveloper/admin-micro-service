class ServiceWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  COMPANY_SERVICE = 'company_service'

  def perform(message)
    message = eval(message)
    if message[:service_id] == COMPANY_SERVICE
      CompanyKafkaSubscriberService.sync_data(message)
    end
  end
end
