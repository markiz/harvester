require 'spec_helper'

describe Harvester::Parser::Children do
  describe "#_parse" do
    subject { described_class.new(:list_items, :selectors => "ol > li") {|c| c.text :content } }
    let(:doc) { Nokogiri::HTML("<body><ol><li>Number one<li>Number two</ol></body>") }
    it "extracts children recursively parses them" do
      subject._parse(doc).should == [{:content => "Number one"}, {:content => "Number two"}]
    end

    it "calls a hook per parsed child" do
      hook = proc {|node, parsed| parsed[:data] = :special; parsed }
      subject.options[:after_parse] = hook
      subject._parse(doc).should == [{:content => "Number one", :data => :special}, {:content => "Number two", :data => :special}]
    end

    it "supports xpath selectors" do
      subject.options[:selectors] = "//ol/li"
      subject._parse(doc).should == [{:content => "Number one"}, {:content => "Number two"}]
    end
  end
end
