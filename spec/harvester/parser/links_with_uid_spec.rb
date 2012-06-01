require 'spec_helper'

describe Harvester::Parser::LinksWithUid do
  describe "#_parse" do
    subject { described_class.new(:forum, :link_regex => /forumdisplay.php/, :uid_keep_params => ["f"]) }
    let(:doc) { Nokogiri::HTML(File.read('spec/fixtures/sample_forum.html')) }
    it "returns parsed url and guid" do
      subject._parse(doc).should include({
        :url => "forumdisplay.php?f=32",
        :uid => "32"
      })
    end

    it "allows using :all for keep_params for uid generation" do
      subject.options[:uid_keep_params] = :all
      subject._parse(doc).should include({
        :url => "forumdisplay.php?f=32",
        :uid => "forumdisplay.php?f=32"
      })
    end

    it "allows using :all_without_query for keep_params for uid generation" do
      subject.options[:uid_keep_params] = :all_without_query
      subject._parse(doc).should include({
        :url => "forumdisplay.php",
        :uid => "forumdisplay.php"
      })
    end

    it "calls an after_parse hook" do
      hook = proc {|node, parsed| parsed[:url] = "/"; parsed }
      subject.options[:after_parse] = hook
      subject._parse(doc).first[:url].should == "/"
    end

    it "allows specifying whether to cut fragment from link" do
      html = Nokogiri::HTML("<a href='/forumdisplay.php?f=1#p123'>forum</a>")
      subject.options[:keep_fragment] = true
      subject._parse(html).first[:url].should == "/forumdisplay.php?f=1#p123"
      subject.options[:keep_fragment] = false
      subject._parse(html).first[:url].should == "/forumdisplay.php?f=1"
    end
  end
end
