require 'spec_helper'

describe Statsy do
  let(:statsy) { Statsy.new }

  context "setup" do
    it "should have api_key getter/setter" do
      statsy = Statsy.new
      statsy.api_key = "abc123"
      statsy.api_key.should == "abc123"
    end

    it "should ahve secret_key getter/setter" do
      statsy.secret_key = "def456"
      statsy.secret_key.should == "def456"
    end

    it "sets api key & secret key when passed to initializer" do
      statsy = Statsy.new("api key", "secret key")
      statsy.api_key.should == "api key"
      statsy.secret_key.should == "secret key"
    end
  end

  context "signature calculation" do
    it "calculates correct signature with no stream prefix" do
      statsy.api_key = "abc123"
      statsy.secret_key = "def456"
      statsy.sign(300).should == "6cpng1sPY9htddzYA/2uADMRovA="
    end

    it "calculates correct signature with stream prefix set" do
      statsy.api_key = "abc123"
      statsy.secret_key = "def456"
      statsy.sign(600, "widgets.melbourne").should == "R1Ro0z/gQw5Mu/R+aKQp7tL7sKE="
    end

    it "raises Statsy::NoAuthParams when not set" do
      lambda { statsy.increment("test.counter") }.should raise_error(Statsy::NoAuthParams)
    end
  end

  context "use statsy" do
    before do
      statsy.api_key = "abc123"
      statsy.secret_key = "def456"
    end

    it "increments with no parameter should increment by one" do
      statsy.should_receive(:send_data).with([{ :stream => "gems.statsy.downloads", :weight => 1 }])
      statsy.increment("gems.statsy.downloads")
    end

    it "increments a stream by the given parameter" do
      statsy.should_receive(:send_data).with([{ :stream => "gems.statsy.downloads", :weight => 5 }])
      statsy.increment("gems.statsy.downloads", 5)
    end
  end
end