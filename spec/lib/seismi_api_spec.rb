require_relative '../spec_helper'

describe Seismi::API::Client do

  let(:client) { Seismi::API::Client.new }

  describe "the basic library api" do

    it "responds to everything it should" do
      client.should respond_to(:where)
      client.should respond_to(:during)
      client.should respond_to(:total)
    end
  end

  describe "for during" do
    it "returns Earthquake objects, given a year" do
      quake = client.during(year: 2011).first
      quake.should respond_to(:src)
      quake.should respond_to(:eqid)
      quake.should respond_to(:timedate)
      quake.should respond_to(:lat)
      quake.should respond_to(:lon)
      quake.should respond_to(:magnitude)
      quake.should respond_to(:depth)
      quake.should respond_to(:region)
    end

    it "gets the 400 most recent earthquakes in a year by default" do
      client.during(year: 2013).size.should == 400
    end
  end

  describe "for total" do

    it "gets the total number of quakes in a year" do
      client.total(year: 2009).should == 408
    end

    it "gets the total number of quakes in a month" do
      client.total(year: 2009, month: 11).should == 120
    end
  end

  describe "caching" do
    
    describe "for total" do

      it "caches requests with the same year arguments" do
        cached_is_faster(:total, {year: 2011}, {year: 2011}).should be_true 
      end

      it "caches requests with different year arguments" do
        cached_is_faster(:total, {year: 2013}, {year: 2009}).should be_true 
      end

      it "caches requests with the same month arguments" do
        cached_is_faster(:total, {year: 2011, month: 11}, 
                         {year: 2011, month: 11}).should be_true 
      end

      it "caches requests with different month arguments" do
        cached_is_faster(:total, {year: 2011, month: 9}, 
                         {year: 2009, month: 7}).should be_true 
      end
    end

    describe "for during" do

      it "caches requests with the same year arguments" do
        cached_is_faster(:during, {year: 2010}, {year: 2010}).should be_true 
      end

      it "caches requests with the same month arguments" do
        cached_is_faster(:during, {year: 2010, month: 6}, 
                         {year: 2010, month: 6}).should be_true 
      end

    end
  end
end
