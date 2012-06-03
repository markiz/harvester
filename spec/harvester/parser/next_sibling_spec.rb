require 'spec_helper'

describe Harvester::Parser::NextSibling do
  let(:doc) {
    Nokogiri::HTML <<-EOF
      <div class='post'>Post</div>
      <div class='info'>
        <a href='http://github.com/a'>Github</a>
        <a href='http://twitter.com/a'>Twitter</a>
      </div>
      <div class='sport'>
        Football!
      </div>
    EOF
  }
  let(:start_node) { doc.at_css('div.post') }

  it "allows extraction of data from next sibling" do
    subject = described_class.new do |h|
      h.link :github, :link_regex => /github/
      h.link :twitter, :link_regex => /twitter/
    end
    result = subject.parse(start_node)

    result[:github].should == "http://github.com/a"
    result[:twitter].should == "http://twitter.com/a"
  end

  it "returns empty hash when there is no next sibling" do
    subject = described_class.new do |h|
      h.link :github, :link_regex => /github/
    end
    subject.parse(doc).should == {}
  end

  it "allows specifying a custom selector for next sibling" do
    subject = described_class.new :selector => 'div.sport' do |h|
      h.text :text
    end
    subject.parse(start_node)[:text].should include('Football!')
  end
end
