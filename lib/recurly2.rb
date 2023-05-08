# Recurly is a Ruby client for Recurly's REST API.
module Recurly3
  require 'recurly3/error'
  require 'recurly3/helper'
  require 'recurly3/api'
  require 'recurly3/resource'
  require 'recurly3/shipping_address'
  require 'recurly3/billing_info'
  require 'recurly3/custom_field'
  require 'recurly3/account_acquisition'
  require 'recurly3/account'
  require 'recurly3/account_balance'
  require 'recurly3/add_on'
  require 'recurly3/address'
  require 'recurly3/tax_detail'
  require 'recurly3/tax_type'
  require 'recurly3/juris_detail'
  require 'recurly3/adjustment'
  require 'recurly3/coupon'
  require 'recurly3/credit_payment'
  require 'recurly3/helper'
  require 'recurly3/invoice'
  require 'recurly3/invoice_collection'
  require 'recurly3/item'
  require 'recurly3/js'
  require 'recurly3/money'
  require 'recurly3/measured_unit'
  require 'recurly3/note'
  require 'recurly3/plan'
  require 'recurly3/redemption'
  require 'recurly3/shipping_fee'
  require 'recurly3/shipping_method'
  require 'recurly3/subscription'
  require 'recurly3/subscription_add_on'
  require 'recurly3/transaction'
  require 'recurly3/usage'
  require 'recurly3/version'
  require 'recurly3/xml'
  require 'recurly3/delivery'
  require 'recurly3/gift_card'
  require 'recurly3/purchase'
  require 'recurly3/webhook'
  require 'recurly3/tier'

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
      Thread.current[:recurly3_config] = config_params
    end

    # @return [String] A subdomain.
    def subdomain
      if Thread.current[:recurly3_config] && Thread.current[:recurly3_config][:subdomain]
        return Thread.current[:recurly3_config][:subdomain]
      end
      @subdomain || 'api'
    end
    attr_writer :subdomain

    # @return [String] An API key.
    # @raise [ConfigurationError] If not configured.
    def api_key
      if Thread.current[:recurly3_config] && Thread.current[:recurly3_config][:api_key]
        return Thread.current[:recurly3_config][:api_key]
      end

      defined? @api_key and @api_key or raise(
        ConfigurationError, "Recurly3.api_key not configured"
      )
    end
    attr_writer :api_key

    # @return [String, nil] A default currency.
    def default_currency
      if Thread.current[:recurly3_config] &&  Thread.current[:recurly3_config][:default_currency]
        return Thread.current[:recurly3_config][:default_currency]
      end

      return  @default_currency if defined? @default_currency
      @default_currency = 'USD'
    end
    attr_writer :default_currency

    # @return [JS] The Recurly3.js module.
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
    #   Recurly3.logger = Logger.new STDOUT
    # @example Rails applications automatically log to the Rails log:
    #   Recurly3.logger = Rails.logger
    # @example Turn off logging entirely:
    #   Recurly3.logger = nil # Or Recurly3.logger = Logger.new nil
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
