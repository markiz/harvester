require 'spec_helper'

describe Harvester::Parser::Base do
  subject { described_class.new(:test) }
  describe "#initialize" do
    it "sets up name" do
      described_class.new(:url).name.should == :url
    end

    it "sets up options" do
      described_class.new(:url, :helper => nil).options.should == {:helper => nil}
    end
  end

  it "has selectors" do
    described_class.new(:test).selectors.should == []
    described_class.new(:test, :selector => "a").selectors.should == ["a"]
    described_class.new(:test, :selectors => ["a"]).selectors.should == ["a"]
  end

  describe "#parse" do
    it "invokes #_parse and returns hash with the result" do
      subject.stub(:_parse).and_return { :hello }
      subject.parse("").should == {:test => :hello}
    end
  end

  describe "#after_parse" do
    it "calls after hook and uses its result when given" do
      after_hook = proc {|*args| @called_with = args; :result }
      subject = described_class.new(:test, :after_parse => after_hook)
      subject.after_parse(1, {}).should == :result
      @called_with.should == [1, {}]
    end

    it "returns last input arg when after hook is undefined" do
      subject = described_class.new(:test)
      subject.after_parse(1, {}).should == {}
    end
  end
end
