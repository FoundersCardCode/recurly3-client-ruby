# Recurly is a Ruby client for Recurly's REST API.
module Recurly2
  require 'recurly2/error'
  require 'recurly2/helper'
  require 'recurly2/api'
  require 'recurly2/resource'
  require 'recurly2/shipping_address'
  require 'recurly2/billing_info'
  require 'recurly2/custom_field'
  require 'recurly2/account_acquisition'
  require 'recurly2/account'
  require 'recurly2/account_balance'
  require 'recurly2/add_on'
  require 'recurly2/address'
  require 'recurly2/tax_detail'
  require 'recurly2/tax_type'
  require 'recurly2/juris_detail'
  require 'recurly2/adjustment'
  require 'recurly2/coupon'
  require 'recurly2/credit_payment'
  require 'recurly2/helper'
  require 'recurly2/invoice'
  require 'recurly2/invoice_collection'
  require 'recurly2/item'
  require 'recurly2/js'
  require 'recurly2/money'
  require 'recurly2/measured_unit'
  require 'recurly2/note'
  require 'recurly2/plan'
  require 'recurly2/redemption'
  require 'recurly2/shipping_fee'
  require 'recurly2/shipping_method'
  require 'recurly2/subscription'
  require 'recurly2/subscription_add_on'
  require 'recurly2/transaction'
  require 'recurly2/usage'
  require 'recurly2/version'
  require 'recurly2/xml'
  require 'recurly2/delivery'
  require 'recurly2/gift_card'
  require 'recurly2/purchase'
  require 'recurly2/webhook'
  require 'recurly2/tier'

  @subdomain = nil

  # This exception is raised if Recurly has not been configured.
  class ConfigurationError < Error
  end

  class << self
    # Set a config based on current thread context.
    # Any default set will say in effect unless overwritten in the config_params.
    # Call this method with out any arguments to have it unset the thread context config values.
    # @param config_params - Hash with the following keys: subdomain, api_key, default_currency
    def config(config_params = nil)
      Thread.current[:recurly2_config] = config_params
    end

    # @return [String] A subdomain.
    def subdomain
      if Thread.current[:recurly2_config] && Thread.current[:recurly2_config][:subdomain]
        return Thread.current[:recurly2_config][:subdomain]
      end
      @subdomain || 'api'
    end
    attr_writer :subdomain

    # @return [String] An API key.
    # @raise [ConfigurationError] If not configured.
    def api_key
      if Thread.current[:recurly2_config] && Thread.current[:recurly2_config][:api_key]
        return Thread.current[:recurly2_config][:api_key]
      end

      defined? @api_key and @api_key or raise(
        ConfigurationError, "Recurly2.api_key not configured"
      )
    end
    attr_writer :api_key

    # @return [String, nil] A default currency.
    def default_currency
      if Thread.current[:recurly2_config] &&  Thread.current[:recurly2_config][:default_currency]
        return Thread.current[:recurly2_config][:default_currency]
      end

      return  @default_currency if defined? @default_currency
      @default_currency = 'USD'
    end
    attr_writer :default_currency

    # @return [JS] The Recurly2.js module.
    def js
      JS
    end

    # Assigns a logger to log requests/responses and more.
    # The logger can only be set if the environment variable
    # `RECURLY_INSECURE_DEBUG` equals `true`.
    #
    # @return [Logger, nil]
    # @example
    #   require 'logger'
    #   Recurly2.logger = Logger.new STDOUT
    # @example Rails applications automatically log to the Rails log:
    #   Recurly2.logger = Rails.logger
    # @example Turn off logging entirely:
    #   Recurly2.logger = nil # Or Recurly2.logger = Logger.new nil
    attr_accessor :logger

    def logger=(logger)
      if ENV['RECURLY_INSECURE_DEBUG'].to_s.downcase == 'true'
        @logger = logger
        puts <<-MSG
        [WARNING] Recurly logger enabled. The logger has the potential to leak
        PII and should never be used in production environments.
        MSG
      else
        puts <<-MSG
        [WARNING] Recurly logger has been disabled. If you wish to use it,
        only do so in a non-production environment and make sure
        the `RECURLY_INSECURE_DEBUG` environment variable is set to `true`.
        MSG
      end
    end

    # Convenience logging method includes a Logger#progname dynamically.
    # @return [true, nil]
    def log level, message
      logger.send(level, name) { message }
    end

    if RUBY_VERSION <= "1.9.0"
      def const_defined? sym, inherit = false
        raise ArgumentError, "inherit must be false" if inherit
        super sym
      end

      def const_get sym, inherit = false
        raise ArgumentError, "inherit must be false" if inherit
        super sym
      end
    end
  end
end
