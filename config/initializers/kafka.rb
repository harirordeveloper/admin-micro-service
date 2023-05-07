require "#{Rails.root}/app/services/kafka_service"

KafkaService.consume("company", "admin_management_api") do |message|
  Rails.logger.debug "Received message: #{message.value}"
end

KafkaService.consume("employee", "company_management_api") do |message|
  Rails.logger.debug "Received message: #{message.value}"
end
