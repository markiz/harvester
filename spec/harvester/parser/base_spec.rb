# encoding: utf-8
require 'spec_helper'

describe Harvester::Parser::Base do
  subject { described_class.new(:test) }
  describe "#initialize" do
    it "sets up name" do
      described_class.new(:url).name.should == :url
    end

    it "sets up options" do
      described_class.new(:url, :helper => nil).options.should == {:helper => nil}
    end
  end

  it "has selectors" do
    described_class.new(:test).selectors.should == []
    described_class.new(:test, :selector => "a").selectors.should == ["a"]
    described_class.new(:test, :selectors => ["a"]).selectors.should == ["a"]
  end

  describe "#parse" do
    it "invokes #_parse and returns hash with the result" do
      subject.stub(:_parse).and_return { :hello }
      subject.parse("").should == {:test => :hello}
    end
  end

  describe "#after_parse" do
    it "calls after hook and uses its result when given" do
      after_hook = proc {|*args| @called_with = args; :result }
      subject = described_class.new(:test, :after_parse => after_hook)
      subject.after_parse(1, {}).should == :result
      @called_with.should == [1, {}]
    end

    it "returns last input arg when after hook is undefined" do
      subject = described_class.new(:test)
      subject.after_parse(1, {}).should == {}
    end
  end

  describe "#node_text" do
    it "converts text nodes to text" do
      node = Nokogiri::HTML.fragment('Hello')
      subject.node_text(node).should == 'Hello'
    end

    it "converts block elements to text with newlines" do
      node = Nokogiri::HTML.fragment('LoL<p>Hello</p>')
      subject.node_text(node).should == "LoL\nHello"
    end

    it "converts <br> to newlines" do
      node = Nokogiri::HTML.fragment('lol<br><br>hello; world<br>yo')
      subject.node_text(node).should == "lol\n\nhello; world\nyo"
    end

    it "should not pass through any html tags" do
      node = Nokogiri::HTML.fragment('Пробую <b>Яндекс</b>.<b>Диск</b> — новый сервис от <b>Яндекса</b><p><a href="http://t.co/kErqTFbS" xhref="http://disk.yandex.ru">disk.yandex.ru</a>')
      subject.node_text(node).should == "Пробую Яндекс.Диск — новый сервис от Яндекса\ndisk.yandex.ru"
    end

    it "removes comments" do
      node = Nokogiri::HTML.fragment('<!-- Hello, world! -->Waka-waka-waka')
      subject.node_text(node).should_not include("Hello")
    end

    it "removes scripts" do
      node = Nokogiri::HTML.fragment('<div><script type="text/javascript">alert(1);</script>Hello, world</div>')
      subject.node_text(node).should_not include("alert")
    end
  end
end
