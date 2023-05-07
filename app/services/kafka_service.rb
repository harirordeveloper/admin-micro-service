class KafkaService

  KAFKA_BROKERS = ENV['KAFKA_BROKERS'].split(',')
  KAFKA_PRODUCER = Kafka.new(
    seed_brokers: KAFKA_BROKERS,
    client_id: 'admin-management'
  )

  KAFKA_CONSUMER = Kafka.new(
    seed_brokers: KAFKA_BROKERS,
    client_id: 'admin-management',
    logger: Rails.logger
  )
  def self.producer
    @producer ||= KAFKA_PRODUCER.producer
  end

  def self.send_message(topic, message)
    producer.produce(message, topic: topic)
    producer.deliver_messages
  end

  def self.consumer
    @consumer ||= KAFKA_CONSUMER.consumer(group_id: "admin_management_api")
  end

  def self.consume(topic, service_name)
    consumer.subscribe(topic)
    Thread.new do
      consumer.each_message do |message|
        ServiceWorker.perform_async(service_name, message.value)
      end
    end
  end
end