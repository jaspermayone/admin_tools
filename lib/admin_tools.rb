# frozen_string_literal: true

require_relative "admin_tools/version"
require_relative "admin_tools/configuration"
require_relative "admin_tools/helper"
require_relative "admin_tools/railtie" if defined?(Rails::Railtie)

module AdminTools
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
