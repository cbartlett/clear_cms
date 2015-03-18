module ClearCMS
  module Middleware
  	class PubSub
      KEEPALIVE_TIME = 15 # in seconds
      CHANNEL        = "clear_cms_messages"

      def initialize(app)
        @app     = app
        @clients = []

        @redis   = Redis.new(:url => ClearCMS.config.sidekiq_redis_url)
        Thread.new do
          redis_sub = Redis.new(:url => ClearCMS.config.sidekiq_redis_url)
          redis_sub.subscribe(CHANNEL) do |on|
            on.message do |channel, msg|
              @clients.each {|ws| ws.send(msg) }
            end
          end
        end

      end

      def call(env)
        if Faye::WebSocket.websocket?(env)
          ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })

          ws.on :open do |event|
            p [:open, ws.object_id]
            @clients << ws
          end

          ws.on :close do |event|
            p [:close, ws.object_id, event.code, event.reason]
            @clients.delete(ws)
            ws = nil
          end

          ws.on :message do |event|
            p [:message, event.data]
            @redis.publish(CHANNEL, event.data)
          end
          
          # Return async Rack response
          ws.rack_response
        else
          @app.call(env)
        end
      end

  	end
  end
end