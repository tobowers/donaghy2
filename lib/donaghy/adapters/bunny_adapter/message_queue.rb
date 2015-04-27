require 'bunny_adapter/event'

module Donaghy
  module BunnyAdapter
    class MessageQueue

      attr_reader :name
      def initialize(name:, channel:nil, options: {})
        @name = name
        @channel = channel || connection.create_channel
        @options = options
      end

      def receive
        _delivery_info, _properties, _payload = bunny_queue.pop
        BunnyAdapter::Event.from_json(payload)
      end

      def publish(event)
        BunnyAdapter.publish(event, name)
      end

    private

      def bunny_queue
        @queue ||= begin
          q = @channel.queue(name, {exclusive: false, auto_delete: false, ack: true}.merge(@options))
          q.bind(BunnyAdapter.exchange, routing_key: name)
          q
        end
      end

      def connection
        BunnyAdapter.connection
      end

    end
  end
end