require 'spec_helper'

describe Harvester::UrlManipulations do
  describe ".uid_from_sliced_params" do
    it "returns sliced params from query values sorted by name" do
      described_class.uid_from_sliced_params("http://google.com/?b=1&a=2&c=3", ["b", "a"]).should == "2_1"
    end

    it "works with empty query" do
      described_class.uid_from_sliced_params("http://google.com/", ["a"]).should == ""
    end
  end
end
