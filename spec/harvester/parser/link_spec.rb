require 'spec_helper'

describe Harvester::Parser::Link do
  describe "#_parse" do
    subject { described_class.new(:github, :link_regex => /github\.com/) }
    let(:node) { Nokogiri::HTML("<body><a href='http://twitter.com/johndoe'>Twitter</a><a href='http://github.com/markiz'>Github</a></body>") }

    it "extracts link with matching url" do
      subject._parse(node).should == "http://github.com/markiz"
    end

    it "calls hook when given" do
      hook = lambda {|node, url| "#{node.text}: #{url}" }
      subject.options[:after_parse] = hook
      subject._parse(node).should == "Github: http://github.com/markiz"
    end

    it "ignores `javascript:` crap" do
      node = Nokogiri::HTML("<body><a href='http://twitter.com/johndoe'>Twitter</a><a href='javascript:alert(\"http://github.com/markiz\")'>Github</a></body>")
      subject._parse(node).should == nil
    end

    it "works with relative links" do
      node = Nokogiri::HTML("<body><a href='http://twitter.com/johndoe'>Twitter</a><a href='/github.com/me'>Github</a></body>")
      subject._parse(node).should == "/github.com/me"
    end
  end
end
