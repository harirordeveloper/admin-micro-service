class ServiceWorker
  include Sidekiq::Worker

  def perform(service_name, message)
    puts "Received message: #{message}"
    case service_name
    when "admin_management_api"
      # process company message
    when "company_management_api"
      # process company message
    when "notification_management_api"
      # process notification message
    end
  end
end