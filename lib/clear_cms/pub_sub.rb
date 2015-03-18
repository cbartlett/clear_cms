module ClearCMS
  class PubSub
    CHANNEL='clear_cms_messages'
    
    def self.publish(message)
      #TODO: Mutex?
      @redis ||= Redis.new(:url=>ClearCMS.config.sidekiq_redis_url)
      @redis.publish(CHANNEL, message)
    end
  end
end