require 'spec_helper'

describe Recurly2.js do
  let(:js) { Recurly2.js }
  describe "public_key" do
    it "must be assignable" do
      js.public_key = 'a_public_key'
      js.public_key.must_equal 'a_public_key'
    end

    it "must raise an exception when not set" do
      if js.instance_variable_defined? :@public_key
        js.send :remove_instance_variable, :@public_key
      end
      proc { Recurly2.js.public_key }.must_raise ConfigurationError
    end

    it "must raise an exception when set to nil" do
      Recurly2.js.public_key = nil
      proc { Recurly2.js.public_key }.must_raise ConfigurationError
    end
  end
end
