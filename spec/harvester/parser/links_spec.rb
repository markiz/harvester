require 'spec_helper'

describe Harvester::Parser::Links do
  subject { described_class.new :github_links, :link_regex => /github.com/ }
  let(:doc) do
    Nokogiri::HTML <<-EOF
      <html>
        <body>
          <a href="/hello/">About me</a>
          <a href="http://github.com/me">My github profile</a>
          <a href="http://github.com/zee">Zee's github profile</a>
        </body>
      </html>
    EOF
  end

  it "extracts links matching provided regex" do
    subject._parse(doc).should == ["http://github.com/me", "http://github.com/zee"]
  end
end
