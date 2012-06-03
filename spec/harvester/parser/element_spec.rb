require 'spec_helper'

describe Harvester::Parser::Element do
  let(:html) { "<body><ol><li class='t'>Number one</li><li class='t'>Number two</li></ol></body>" }
  let(:doc) { Nokogiri::HTML(html) }
  subject { described_class.new(:test, :selectors => 'li.t') }
  describe "#_parse" do
    it "finds an element matching given selector and returns element text" do
      subject._parse(doc).should == 'Number one'
    end

    it "returns nil when there is no matching node" do
      subject._parse(Nokogiri::HTML("")).should be_nil
    end

    it "calls after_parse hook when given" do
      hook = lambda {|node, text| text + ": Hello"}
      subject.options[:after_parse] = hook
      subject._parse(doc).should == "Number one: Hello"
    end

    it "supports xpath selectors" do
      subject.options[:selectors] = "//li[@class='t']"
      subject._parse(doc).should == "Number one"
    end
  end
end
