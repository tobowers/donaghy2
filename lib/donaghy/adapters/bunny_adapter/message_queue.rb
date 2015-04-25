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
        delivery_info, properties, payload = bunny_queue.pop
        {delivery_info: delivery_info, properties: properties, payload: payload}
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