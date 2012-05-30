require 'spec_helper'

describe Harvester::Parser::LinkWithUid do
  describe "#parse" do
    subject { described_class.new(:forum, :link_regex => /forumdisplay.php/, :uid_keep_params => ["f"]) }
    let(:doc) { Nokogiri::HTML(File.read('spec/fixtures/sample_forum.html')) }
    it "returns parsed url and guid" do
      subject.parse(doc).should == {
        :forum_url => "forumdisplay.php?f=32",
        :forum_uid => "32"
      }
    end

    it "allows for returned keys redefinition" do
      subject.options[:url_key] = :url
      subject.options[:uid_key] = :guid
      subject.parse(doc).should == {
        :url  => "forumdisplay.php?f=32",
        :guid => "32"
      }
    end

    it "calls an after_parse hook" do
      hook = proc {|node, parsed| parsed[:forum_url] = "/"; parsed }
      subject.options[:after_parse] = hook
      subject.parse(doc)[:forum_url].should == "/"
    end
  end
end
