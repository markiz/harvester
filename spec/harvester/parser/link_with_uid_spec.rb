require 'spec_helper'

describe Harvester::Parser::LinkWithUid do
  describe "#parse" do
    subject { described_class.new(:forum, :link_regex => /forumdisplay.php/, :uid_keep_params => ["f"]) }
    let(:doc) { Nokogiri::HTML(File.read('spec/fixtures/sample_forum.html')) }
    it "returns parsed url and guid" do
      subject._parse(doc).should == {
        :url => "forumdisplay.php?f=32",
        :uid => "32"
      }
    end

    it "allows using :all for keep_params for uid generation" do
      subject.options[:uid_keep_params] = :all
      subject._parse(doc).should == {
        :url => "forumdisplay.php?f=32",
        :uid => "forumdisplay.php?f=32"
      }
    end

    it "allows using :all_without_query for keep_params for uid generation" do
      subject.options[:uid_keep_params] = :all_without_query
      subject._parse(doc).should == {
        :url => "forumdisplay.php",
        :uid => "forumdisplay.php"
      }
    end

    it "calls an after_parse hook" do
      hook = proc {|node, parsed| parsed[:url] = "/"; parsed }
      subject.options[:after_parse] = hook
      subject._parse(doc)[:url].should == "/"
    end
  end
end
