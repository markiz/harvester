require 'spec_helper'

describe Harvester::Parser::Text do
  describe "#_parse" do
    let(:node) { Nokogiri::HTML("<body><h1>Hello, world</h1><p>Paragraph</p></body>").at_css("h1") }
    subject { described_class.new(:header) }

    it "returns node text" do
      subject._parse(node).should == "Hello, world"
    end

    it "calls after_parse hook when given" do
      hook = lambda {|node, text| "Well, #{text}" }
      subject.options[:after_parse] = hook
      subject._parse(node).should == "Well, Hello, world"
    end
  end
end
