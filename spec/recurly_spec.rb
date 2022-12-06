require 'spec_helper'

describe Recurly do
  describe "api key" do

    it "must be assignable" do
      Recurly2.api_key = 'new_key'
      Recurly2.api_key.must_equal 'new_key'
    end

    it "must raise an exception when not set" do
      if Recurly2.instance_variable_defined? :@api_key
        Recurly2.send :remove_instance_variable, :@api_key
      end
      proc { Recurly2.api_key }.must_raise ConfigurationError
    end

    it "must raise an exception when set to nil" do
      Recurly2.api_key = nil
      proc { Recurly2.api_key }.must_raise ConfigurationError
    end

    it "must use defaults set if not sent in new thread" do
      Recurly2.api_key = 'old_key'
      Recurly2.subdomain = 'olddomain'
      Recurly2.default_currency = 'US'
      Thread.new {
        Recurly2.api_key.must_equal 'old_key'
        Recurly2.subdomain.must_equal 'olddomain'
        Recurly2.default_currency.must_equal 'US'
      }
    end

    it "must use new values set in thread context" do
      Recurly2.api_key = 'old_key'
      Recurly2.subdomain = 'olddomain'
      Recurly2.default_currency = 'US'
      Thread.new {
          Recurly2.config(api_key: "test", subdomain: "testsub", default_currency: "IR")
          Recurly2.api_key.must_equal 'test'
          Recurly2.subdomain.must_equal 'testsub'
          Recurly2.default_currency.must_equal 'IR'
      }
      Recurly2.api_key.must_equal 'old_key'
      Recurly2.subdomain.must_equal 'olddomain'
      Recurly2.default_currency.must_equal 'US'
    end
  end
end
