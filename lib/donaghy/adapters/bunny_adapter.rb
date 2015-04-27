require 'monitor'
require 'bunny'

require 'pry'

$LOAD_PATH.unshift(File.dirname(__FILE__))

module Donaghy
  module BunnyAdapter
    # using the slower monitor as it's thread re-entrant. We avoid actually having to synchronize
    # except in the initialization case
    MONITOR = Monitor.new

    def self.connection
      return @connection if @connection
      MONITOR.synchronize do
        return @connection if @connection
        @connection = Bunny.new.tap {|conn| conn.start }
      end
    end

    def self.publish(key, event)
      binding.pry
      exchange.publish(event.to_json, routing_key: key)
    end

    def self.exchange
      return @exchange if @exchange
      MONITOR.synchronize do
        return @exchange if @exchange
        @exchange = root_channel.topic("donaghy_#{Donaghy.donaghy_env}", :auto_delete => false)
      end
    end

    def self.root_channel
      return @root_channel if @root_channel
      MONITOR.synchronize do
        return @root_channel if @root_channel
        @root_channel = self.connection.create_channel
      end
    end

  end
end

require 'bunny_adapter/message_queue'
