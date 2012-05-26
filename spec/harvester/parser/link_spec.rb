require 'spec_helper'

describe Harvester::Parser::Link do
  describe "#_parse" do
    let(:node) { Nokogiri::HTML("<body><a href='http://twitter.com/johndoe'>Twitter</a><a href='http://github.com/markiz'>Github</a></body>") }
    it "extracts link with matching url" do
      subject = described_class.new(:github, :link_regex => /github\.com/)
      subject._parse(node).should == "http://github.com/markiz"
    end
  end
end
