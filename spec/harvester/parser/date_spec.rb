require 'spec_helper'

describe Harvester::Parser::Date do
  let(:html) { "<body><span>Author: Unknown</span><span>Published at: 03/05/12 22:30</span><div>Article</div></body>" }
  let(:doc) { Nokogiri::HTML(html) }
  let(:described_class) { Harvester::Parser::Date }
  subject { described_class.new(:published_at, :selectors => "span") }

  describe "#_parse" do
    it "matches an element with proper format and extracts date from it" do
      subject._parse(doc).should be_within(24*3600).of(Time.utc(2012, 3, 5, 22, 30))
    end

    it "allows for before_parse hook" do
      subject.options[:before_parse] = proc {|t| "2000/1/1" }
      subject._parse(doc).should be_within(24*3600).of(Time.utc(2000, 1, 1))
    end

    it "supports xpath selectors" do
      subject.options[:selectors] = "//span"
      subject._parse(doc).should be_within(24*3600).of(Time.utc(2012, 3, 5, 22, 30))
    end
  end

  describe "with russian locale" do
    let(:html) { "<body><span>Author: Unknown</span><span>Published at: 03.05.12 22:30</span><div>Article</div></body>" }
    let(:doc) { Nokogiri::HTML(html) }
    subject { described_class.new(:published_at, :selectors => "span", :regex => /:(.*\d{2}:\d{2})$/, :locale => :ru) }
    it "understands russian date format DD.MM.YY(YY)" do
      subject._parse(doc).should be_within(24*3600).of(Time.utc(2012, 5, 3, 22, 30))
    end
  end

end
