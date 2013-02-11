require 'spec_helper'

describe Harvester::URLSlicer do
  subject { described_class }
  it "raises argument error when passed nil" do
    expect { subject.call(nil, :all) }.to raise_error(ArgumentError)
  end

  describe "uid extraction" do
    it "returns sliced params from query values sorted by name" do
      subject.call("http://google.com/?b=1&a=2&c=3", ["b", "a"]).uid.should == "2_1"
    end

    it "works with empty query" do
      subject.call("http://google.com/", ["a"]).uid.should == ""
    end

    it "truncates query for :all_without_query argument" do
      subject.call("http://google.com/?q=hello", :all_without_query).uid.should == "http://google.com/"
    end

    it "returns url unchanged for :all and nil argument" do
      url = "http://google.com/?b=10&c=20"
      subject.call(url, :all).uid.should == url
      subject.call(url, nil).uid.should == url
    end

    it "keeps fragment when asked" do
      url = "http://google.com/?b=10#wtf"
      subject.call(url, :all, false).uid.should == "http://google.com/?b=10"
      subject.call(url, :all, true).uid.should == url
    end
  end

  describe "url extraction" do
    it "only keeps specified query params" do
      subject.call("http://google.com/?q=hello&src=chrome", ["q"]).url.should == "http://google.com/?q=hello"
    end

    it "works with empty query" do
      subject.call("http://google.com/", ["q"]).url.should == "http://google.com/"
    end

    it "truncates query for :all_without_query argument" do
      subject.call("http://google.com/?q=hello", :all_without_query).url.should == "http://google.com/"
    end

    it "returns url unchanged for :all and nil slice types" do
      url = "http://google.com/?q=hello"
      subject.call(url, :all).url.should == url
      subject.call(url, nil).url.should == url
    end

    it "keeps fragment when asked" do
      subject.call("http://google.com/?q=hello#wtf", :all, false).url.should == "http://google.com/?q=hello"
      subject.call("http://google.com/?q=hello#wtf", :all, true).url.should == "http://google.com/?q=hello#wtf"
    end
  end
end
