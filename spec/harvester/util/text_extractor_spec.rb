# encoding: utf-8
require 'spec_helper'

describe Util::TextExtractor do
  subject { described_class }

  it "converts text nodes to text" do
    node = Nokogiri::HTML.fragment('Hello')
    subject.call(node).should == 'Hello'
  end

  it "converts block elements to text with newlines" do
    node = Nokogiri::HTML.fragment('LoL<p>Hello</p>')
    subject.call(node).should == "LoL\nHello"
  end

  it "converts <br> to newlines" do
    node = Nokogiri::HTML.fragment('lol<br><br>hello; world<br>yo')
    subject.call(node).should == "lol\n\nhello; world\nyo"
  end

  it "should not pass through any html tags" do
    node = Nokogiri::HTML.fragment('Пробую <b>Яндекс</b>.<b>Диск</b> — новый сервис от <b>Яндекса</b><p><a href="http://t.co/kErqTFbS" xhref="http://disk.yandex.ru">disk.yandex.ru</a>')
    subject.call(node).should == "Пробую Яндекс.Диск — новый сервис от Яндекса\ndisk.yandex.ru"
  end

  it "removes comments" do
    node = Nokogiri::HTML.fragment('<!-- Hello, world! -->Waka-waka-waka')
    subject.call(node).should_not include("Hello")
  end

  it "removes scripts" do
    node = Nokogiri::HTML.fragment('<div><script type="text/javascript">alert(1);</script>Hello, world</div>')
    subject.call(node).should_not include("alert")
  end
end
