Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    #chain.add Kiqstand::Middleware
  end

  config.redis = { :url => ClearCMS.config.sidekiq_redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ClearCMS.config.sidekiq_redis_url }
end