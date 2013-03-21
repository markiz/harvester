require 'spec_helper'


describe Harvester::Parser::Elements do
  subject { described_class.new(:paragraphs, :selector => 'p') }
  let(:html) {
    Nokogiri::HTML <<-EOF
      <p class='first'>First paragraph</p>
      <p class='second'>Second paragraph</p>
      <div>Don't mind me, I am an ad</div>
      <p class='third'>Third paragraph</p>
    EOF
  }

  it "concatenates all matching elements together" do
    subject._parse(html).should == "First paragraph\nSecond paragraph\nThird paragraph"
  end

  it "can be filtered by regexes" do
    subject.options[:regex] = /First/
    subject._parse(html).should == "First paragraph"
  end

  it "can be filtered by negative regexes" do
    subject.options[:negative_regex] = /Second/
    subject._parse(html).should == "First paragraph\nThird paragraph"
  end
end
