class CompanyKafkaSubscriberService
   def self.sync_data message
    resource = message[:resource].constantize
    resource.sync_data(message)
   end
end