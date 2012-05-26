require 'spec_helper'

describe Harvester::Parser do
  it "has parser nodes" do
    described_class.new.parser_nodes.should == []
  end

  describe "#parse" do
    it "iterates over parser nodes and merges the results" do
      subject.parser_nodes << stub(:parse => {:hello => "World"})
      subject.parser_nodes << stub(:parse => {:moon  => "Light"})
      subject.parse("").should == {:hello => "World", :moon => "Light"}
    end

    it "converts strings to nokogiri docs" do
      parser = stub
      subject.parser_nodes << parser
      parser.should_receive(:parse).
          with(kind_of(Nokogiri::HTML::Document)).
          and_return({})
      subject.parse("")
    end
  end
end
