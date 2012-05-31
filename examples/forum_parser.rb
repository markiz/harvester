# encoding: utf-8
$:.unshift File.expand_path("../../lib", __FILE__)
require 'pp'
require 'harvester'
require 'bundler/setup'
# When author link text is empty, use "Anonymous"
author_normalization = proc do |node, author|
  author[:name] = author[:link] && author[:link][:text].size > 0 ? author[:link][:text] : "Anonymous"
  author
end


harvester = Harvester.new do |p|
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
          :selectors       => "a:last-child",
          :link_regex      => /memberlist\.php.*viewprofile/,
          :uid_keep_params => ["mode", "u"],
          :after_parse     => proc {|node, parsed| parsed[:text] = node.text; parsed }
    end
  end
end

# http://www.phpbb.com/community/viewtopic.php?t=2156784
forum_thread = File.read('spec/fixtures/phpbb_forum_thread.html')

pp harvester.parse(forum_thread)
# {:title=>"statistics report",
#  :posts=>
#   [{:title=>"statistics report",
#     :body=>
#      "Is there any way to pull a report of statistics (e.g. active posts, content and sender) from the standard phpbb? Or do I have to install some other module to obtain this information? If so, which one? There is a lot of varieties of which some seem very old and have warnings to them from this support.",
#     :published_at=>2012-05-29 12:09:00 +0400,
#     :link=>{:url=>"./viewtopic.php?p=13150823#p13150823", :uid=>"13150823"},
#     :author=>
#      {:link=>
#        {:url=>"./memberlist.php?mode=viewprofile&u=1345591",
#         :uid=>"viewprofile_1345591",
#         :text=>"blocum"},
#       :name=>"blocum"}},
#    {:title=>"Re: statistics report",
#     :body=>"Did you see phpBB statistics?",
#     :published_at=>2012-05-30 08:59:00 +0400,
#     :link=>{:url=>"./viewtopic.php?p=13151077#p13151077", :uid=>"13151077"},
#     :author=>
#      {:link=>
#        {:url=>"./memberlist.php?mode=viewprofile&u=719195",
#         :uid=>"viewprofile_719195",
#         :text=>"Mick"},
#       :name=>"Mick"}},
#    {:title=>"Re: statistics report",
#     :body=>
#      "Yes I found it but it has no specifications on where to install, what it does and in the discussion tab you can see that there is a lot of problems attached to it. As it is a year old I hesitated if I had found the latest version. Is there a module description? Is it supported by phpBB?",
#     :published_at=>2012-05-30 11:24:00 +0400,
#     :link=>{:url=>"./viewtopic.php?p=13151109#p13151109", :uid=>"13151109"},
#     :author=>
#      {:link=>
#        {:url=>"./memberlist.php?mode=viewprofile&u=1345591",
#         :uid=>"viewprofile_1345591",
#         :text=>"blocum"},
#       :name=>"blocum"}},
#    {:title=>"Re: statistics report",
#     :body=>
#      "No MODs are supported by phpBB only by the author and the community.The place to look for information or ask about the the features of a MOD is the Discussion/Support forum for the MOD.Instructions for installing MODs are in the install.xml file contained in the MOD package.For general information on installing MODs see:Installing MODs the Right Way[Tutorial] How to install a MODX modificationAnd/or Opening MODs and Installing MODsAutoMOD is an automated tool that can be used for installing most recent MODs. See also, Installing AutoMOD, and for how to use it, Installing MODs with AutoMOD.You will need to use appropriate tools to make the changes, see Tools needed to set up and customise phpBB.",
#     :published_at=>2012-05-30 11:53:00 +0400,
#     :link=>{:url=>"./viewtopic.php?p=13151112#p13151112", :uid=>"13151112"},
#     :author=>
#      {:link=>
#        {:url=>"./memberlist.php?mode=viewprofile&u=987265",
#         :uid=>"viewprofile_987265",
#         :text=>"Oyabun1"},
#       :name=>"Oyabun1"}},
#    {:title=>"Re: statistics report",
#     :body=>"OK thanks for your information. I will test this.",
#     :published_at=>2012-05-31 07:38:00 +0400,
#     :link=>{:url=>"./viewtopic.php?p=13151358#p13151358", :uid=>"13151358"},
#     :author=>
#      {:link=>
#        {:url=>"./memberlist.php?mode=viewprofile&u=1345591",
#         :uid=>"viewprofile_1345591",
#         :text=>"blocum"},
#       :name=>"blocum"}}]}
