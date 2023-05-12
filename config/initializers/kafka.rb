require "#{Rails.root}/app/services/kafka_service"

Thread.new do
  KafkaService.consume("company")
  KafkaService.consume("employee")
end