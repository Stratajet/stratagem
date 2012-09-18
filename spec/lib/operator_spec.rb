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
        (connection = double('connection')).stub(:request).and_return([{"departure_time"=>"2012-01-01T01:00:00Z", "arrival_time"=>"2012-01-01T02:00:00Z", "from_airfield_id"=>"egll", "to_airfield_id"=>"eglc", "aircraft_id"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "id"=>"vbad51hh"}])
        @operator.instance_eval { @connection = connection}

        events = @operator.index
        events.count.should == 1
        events.first.class.should == StrataGem::Event
        events.first.from_airfield_id.should == "egll"
      end
    end
    
    describe "#get" do
      it "should return the correct data" do
        (connection = double('connection')).stub(:request).and_return({"departure_time"=>"2012-01-01T01:00:00Z", "arrival_time"=>"2012-01-01T02:00:00Z", "from_airfield_id"=>"egll", "to_airfield_id"=>"eglc", "aircraft_id"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "id"=>"vbad51hh"})
        @operator.instance_eval { @connection = connection}

        event = @operator.get("vbad51hh")
        event.class.should == StrataGem::Event
        event.from_airfield_id.should == "egll"
        event.id.should == "vbad51hh"
      end
    end
    
    
  end
  
  
end