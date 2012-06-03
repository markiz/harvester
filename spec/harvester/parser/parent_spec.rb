require 'spec_helper'

describe Harvester::Parser::Parent do
  let(:doc) {
    Nokogiri::HTML <<-EOF
      <div class='post'>
        <title>post title</title>
        <div class='section'>
          <title>section title</title>
          <div class='body'>section body</div>
        </div>
      </div>
    EOF
  }
  let(:start_node) { doc.at_css('div.body') }

  it "allows extraction of data from parent" do
    subject = described_class.new do |h|
      h.element :title, :selector => "title"
    end
    result = subject.parse(start_node)
    result[:title].should == "section title"
  end

  it "returns empty hash when there is no parent" do
    subject = described_class.new do |h|
      h.element :title, :selector => "title"
    end
    subject.parse(doc).should == {}
  end

  it "allows specifying a custom selector for next sibling" do
    subject = described_class.new :selector => 'div.post' do |h|
      h.element :title, :selector => "title"
    end
    subject.parse(start_node)[:title].should == 'post title'
  end
end
