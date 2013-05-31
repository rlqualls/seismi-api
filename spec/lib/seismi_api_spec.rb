require_relative '../spec_helper'

describe Seismi::API::Client do

  let(:client) { Seismi::API::Client.new }

  describe "during" do
    it "returns Earthquake objects, given a year" do
      quake = client.during_year(2011)[0]
      quake.should respond_to(:src)
      quake.should respond_to(:eqid)
      quake.should respond_to(:timedate)
      quake.should respond_to(:lat)
      quake.should respond_to(:lon)
      quake.should respond_to(:magnitude)
      quake.should respond_to(:depth)
      quake.should respond_to(:region)
    end

    it "gets all the earthquakes that happened in a year" do
      client.during_year(2013).size.should > 399
    end
  end

  describe "totals" do

    it "gets the total number of earthquakes in a year" do
      client.yearly_total(2009).should == 408
    end 

    it "gets the total number of earthquakes in a year and a month" do
      client.monthly_total(2009, 11).should == 120
    end
  end
end
