require 'spec_helper'

describe Recurly do
  describe "api key" do

    it "must be assignable" do
      Recurly3.api_key = 'new_key'
      Recurly3.api_key.must_equal 'new_key'
    end

    it "must raise an exception when not set" do
      if Recurly3.instance_variable_defined? :@api_key
        Recurly3.send :remove_instance_variable, :@api_key
      end
      proc { Recurly3.api_key }.must_raise ConfigurationError
    end

    it "must raise an exception when set to nil" do
      Recurly3.api_key = nil
      proc { Recurly3.api_key }.must_raise ConfigurationError
    end

    it "must use defaults set if not sent in new thread" do
      Recurly3.api_key = 'old_key'
      Recurly3.subdomain = 'olddomain'
      Recurly3.default_currency = 'US'
      Thread.new {
        Recurly3.api_key.must_equal 'old_key'
        Recurly3.subdomain.must_equal 'olddomain'
        Recurly3.default_currency.must_equal 'US'
      }
    end

    it "must use new values set in thread context" do
      Recurly3.api_key = 'old_key'
      Recurly3.subdomain = 'olddomain'
      Recurly3.default_currency = 'US'
      Thread.new {
          Recurly3.config(api_key: "test", subdomain: "testsub", default_currency: "IR")
          Recurly3.api_key.must_equal 'test'
          Recurly3.subdomain.must_equal 'testsub'
          Recurly3.default_currency.must_equal 'IR'
      }
      Recurly3.api_key.must_equal 'old_key'
      Recurly3.subdomain.must_equal 'olddomain'
      Recurly3.default_currency.must_equal 'US'
    end
  end
end
