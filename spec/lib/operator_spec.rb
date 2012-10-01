require 'spec_helper'
describe StrataGem::Operator do
  
  describe "#initialize" do
    it "stores the token and creates an OAuth client and access" do
      operator = StrataGem::Operator.new("app_id", "secret", "token")
      operator.instance_eval do
        @connection.class.should == StrataGem::Connection
      end
    end
  end
  
  context "connections" do
    before (:all) do
      @data_returned = nil
      @operator = StrataGem::Operator.new("app_id", "secret", "token")
    end
    
    
    describe "#index" do
      it "should return the correct data" do
        (connection = double('connection')).stub(:request).and_return([{"start_time"=>"2012-01-01T01:00:00Z", "end_time"=>"2012-01-01T02:00:00Z", "start_airfield"=>"egll", "end_airfield"=>"eglc", "aircraft_registration"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "deleted"=>1, "data_source"=>"Strata", "data_source_unique_id"=>123, "id"=>"vbad51hh"}])
        @operator.instance_eval { @connection = connection}

        events = @operator.index
        events.count.should == 1
        events.first.class.should == StrataGem::Event
        events.first.start_airfield.should == "egll"
      end
    end
    
    describe "#index_by_aircraft" do
      it "should return the correct data" do
        (connection = double('connection')).stub(:request).and_return([{"start_time"=>"2012-01-01T01:00:00Z", "end_time"=>"2012-01-01T02:00:00Z", "start_airfield"=>"egll", "end_airfield"=>"eglc", "aircraft_registration"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "deleted"=>1, "data_source"=>"Strata", "data_source_unique_id"=>123, "id"=>"vbad51hh"}])
        @operator.instance_eval { @connection = connection}

        events = @operator.index_by_aircraft("g-alex")
        events.count.should == 1
        events.first.class.should == StrataGem::Event
        events.first.start_airfield.should == "egll"
      end
    end
    
    describe "#get" do
      it "should return the correct data" do
        (connection = double('connection')).stub(:request).and_return({"start_time"=>"2012-01-01T01:00:00Z", "end_time"=>"2012-01-01T02:00:00Z", "start_airfield"=>"egll", "end_airfield"=>"eglc", "aircraft_registration"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "deleted"=>1, "data_source"=>"Strata", "data_source_unique_id"=>123, "id"=>"vbad51hh"})
        @operator.instance_eval { @connection = connection}

        event = @operator.get("vbad51hh")
        event.class.should == StrataGem::Event
        event.start_airfield.should == "egll"
        event.id.should == "vbad51hh"
      end
    end

    describe "#get_by_unique" do
      it "should return the correct data" do
        (connection = double('connection')).stub(:request).and_return({"start_time"=>"2012-01-01T01:00:00Z", "end_time"=>"2012-01-01T02:00:00Z", "start_airfield"=>"egll", "end_airfield"=>"eglc", "aircraft_registration"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "deleted"=>1, "data_source"=>"Strata", "data_source_unique_id"=>123, "id"=>"vbad51hh"})
        @operator.instance_eval { @connection = connection}

        event = @operator.get_by_unique("vbad51hh")
        event.class.should == StrataGem::Event
        event.start_airfield.should == "egll"
        event.id.should == "vbad51hh"
      end
    end


    describe "#create_in_batch" do
      it "should return the correct data" do
        (connection = double('connection')).stub(:request).and_return(true)
        @operator.instance_eval { @connection = connection}
        event = StrataGem::Event.new(@operator, {})

        @operator.create_in_batch([event]).should == true
      end
    end
    
  end
  
  
end