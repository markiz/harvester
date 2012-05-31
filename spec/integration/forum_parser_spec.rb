# encoding: utf-8
require 'spec_helper'

describe Harvester do
  describe "parsing forum section" do
    let(:html) { File.read("spec/fixtures/phpbb_forum_section.html") }
    let(:doc) { Nokogiri::HTML(html) }
    subject do
      Harvester::Parser.new do |p|
        p.element :title, :selectors => "h2 > a"
        p.links_with_uid :subsections,
            :selectors       => "a.forumtitle",
            :link_regex      => /viewforum\.php.*f=\d+/,
            :uid_keep_params => ["f"]
        p.links_with_uid :threads,
            :selectors       => "a.topictitle",
            :link_regex      => /viewtopic\.php.*t=\d+/,
            :uid_keep_params => ["t"]
      end
    end

    it "can gather links to subsections" do
      result = subject.parse(doc)
      result[:subsections].should include({:url => "./viewforum.php?f=65", :uid => "65"})
    end

    it "can gather links to threads" do
      result = subject.parse(doc)
      result[:threads].should include({:url => "./viewtopic.php?t=543515", :uid => "543515"})
    end

    it "can gather forum title" do
      subject.parse(doc)[:title].should == "3.0.x Support Forum"
    end
  end

  describe "parsing forum thread" do
    let(:html) { File.read("spec/fixtures/phpbb_forum_thread.html") }
    let(:doc) { Nokogiri::HTML(html) }
    let(:author_normalization) do
      proc do |node, author|
        author[:name] = author[:link] ? author[:link].delete(:text) : "Anonymous"
        author
      end
    end
    subject do
      Harvester::Parser.new do |p|
        p.element :title, :selectors => "h2 > a"
        p.children :posts, :selectors => "div.post" do |post|
          post.element :title, :selectors => "h3"
          post.element :body, :selectors => "div.content"
          post.date :published_at, :selectors => "p.author", :regex => /» (.*)$/
          post.link_with_uid :link,
              :selectors       => "p.author > a",
              :link_regex      => /viewtopic\.php.*p=\d+/,
              :uid_keep_params => "p",
              :keep_fragment   => true
          post.child :author, :selectors => "dl.postprofile", :after_parse => author_normalization do |author|
            author.link_with_uid :link,
                :selectors       => "a",
                :link_regex      => /memberlist\.php.*viewprofile/,
                :uid_keep_params => ["mode", "u"],
                :after_parse     => proc {|node, parsed| parsed[:text] = node.text; parsed }
          end
        end
      end
    end

    it "parses thread title" do
      subject.parse(doc)[:title].should == "statistics report"
    end

    it "parses thread posts" do
      posts = subject.parse(doc)[:posts]
      posts.count.should == 5
      posts[0][:title].should == "statistics report"
      posts[0][:body].should include("Is there any way to pull a report")
      posts[0][:author][:link][:url].should == "./memberlist.php?mode=viewprofile&u=1345591"
      posts[0][:author][:link][:uid].should == "viewprofile_1345591"
      posts[0][:author][:name].should == "blocum"
      posts[0][:published_at].should be_within(24*3600).of(Time.utc(2012, 5, 29, 12, 9))
    end

  end
end
