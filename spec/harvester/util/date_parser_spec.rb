# encoding: utf-8
require 'spec_helper'
describe Harvester::DateParser do
  describe "with default locale" do
    it "parses various formats of dates" do
      described_class.parse("15 Jan 2010 05:30").should be_within(24*3600).of(Time.utc(2010, 1, 15, 5, 30))
    end
  end

  describe "with :ru locale" do
    it "understands russian months" do
      described_class.parse("15 янв 2010 05:30", :ru).should be_within(24*3600).of(Time.utc(2010, 1, 15, 5, 30))
    end

    it "understands russian date format" do
      described_class.parse("08.03.12 15:30", :ru).should be_within(24*3600).of(Time.utc(2012, 3, 8, 15, 30))
    end
  end
end
