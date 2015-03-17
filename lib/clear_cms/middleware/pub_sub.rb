module ClearCMS
  module Middleware
  	class PubSub
      KEEPALIVE_TIME = 15 # in seconds

      def initialize(app)
        @app     = app
        @clients = []

        @running=Thread.new do
        # redis_sub = Redis.new(host: uri.host, port: uri.port, password: uri.password)
        # redis_sub.subscribe(CHANNEL) do |on|
        #   on.message do |channel, msg|
          counter=0
          loop do
            msg='{"model": "content", "data": "We have run this loop again."}'
            @clients.each {|ws| ws.send(msg) }
            sleep 5
            counter+=1
          end
        #end
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
            @clients.each {|client| client.send(event.data) }
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