require "donaghy/version"
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'monitor'
require 'celluloid'
require 'socket'
require 'configliere'


module Donaghy
  CONFIG_GUARD = Monitor.new

  class MissingConfigurationFile < StandardError; end

  def self.donaghy_env
    ENV['DONAGHY_ENV'] || ENV['RAILS_ENV'] || 'development'
  end

  def self.configuration
    return @configuration if @configuration
    @configuration = Configuration.new
    @configuration.defaults(default_config)
    @configuration
  end

  def self.logger
    return @logger if @logger
    CONFIG_GUARD.synchronize do
      @logger = Celluloid.logger unless @logger
    end
    @logger
  end

  def self.logger=(logger)
    CONFIG_GUARD.synchronize do
      @logger = Celluloid.logger = logger
    end
  end

  def self.configuration=(opts)
    CONFIG_GUARD.synchronize do
      config_file = opts[:config_file]
      configuration.read("/mnt/configs/donaghy_resources.yml")
      configuration.read("config/donaghy.yml")
      if config_file
        raise MissingConfigurationFile, "Config file: #{config_file} does not exist" unless File.exists?(config_file)
        configuration.read(config_file)
      end
      configuration.defaults(opts)
      configuration.defaults(queue_name: configuration[:name]) unless configuration[:queue_name]
      version_file_path = "config/version.txt"
      if File.exists?(version_file_path)
        configuration["#{configuration[:name]}_version"] = File.read(version_file_path)
      end
      configuration.resolve!
      logger.info("Donaghy configuration is now: #{configuration.inspect}")
      configuration
    end
  end

  def self.hostname
    return @hostname if @hostname
    CONFIG_GUARD.synchronize do
      @hostname = Socket.gethostname unless @hostname
    end
    @hostname
  end

  def self.default_config
    {
        name: "#{hostname}_#{Celluloid::UUID.generate}",
        pwd: Dir.pwd,
        concurrency: Celluloid.cores
    }
  end
end

$: << File.dirname(__FILE__)

require 'active_support/core_ext/string/inflections'
require 'configliere'

require 'donaghy/logging'
require 'donaghy/configuration'
require 'donaghy/event'
require 'donaghy/fetcher'

require 'donaghy/adapters/bunny_adapter'


