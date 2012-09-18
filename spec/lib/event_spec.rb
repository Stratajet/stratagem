require 'spec_helper'
describe StrataGem::Operator do
  
  describe "#initialize" do
    it "stores the data ad allows it to be retrieved" do
      event = StrataGem::Event.new({"departure_time"=>"2012-01-01T01:00:00Z", "arrival_time"=>"2012-01-01T02:00:00Z", "from_airfield_id"=>"egll", "to_airfield_id"=>"eglc", "aircraft_id"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "id"=>"vbad51hh"}, operator = StrataGem::Operator.new("app_id", "secret", "token"))
      event.departure_time.should == "2012-01-01T01:00:00Z"
      event.arrival_time.should == "2012-01-01T02:00:00Z"
      event.from_airfield_id.should == "egll"
      event.to_airfield_id.should == "eglc"
      event.utilization.should == "PAX"
      event.utilization_count.should == 2
      event.aircraft_id.should == "g-alex"
      event.id.should == "vbad51hh"
      event.operator.should == operator
    end
    
    it "raises an exception if an operator is not provided" do
      expect {StrataGem::Event.new({}, nil)}.to raise_error(StrataGem::ArgumentError)
    end
    
  end
  
  describe "#to_send" do
    it "creates a hash of the attributes" do
      event = StrataGem::Event.new({"departure_time"=>"2012-01-01T01:00:00Z", "arrival_time"=>"2012-01-01T02:00:00Z", "from_airfield_id"=>"egll", "to_airfield_id"=>"eglc", "aircraft_id"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "id"=>"vbad51hh"}, StrataGem::Operator.new("app_id", "secret", "token"))
      event.to_send.should == {"departure_time"=>"2012-01-01T01:00:00Z", "arrival_time"=>"2012-01-01T02:00:00Z", "from_airfield_id"=>"egll", "to_airfield_id"=>"eglc", "aircraft_id"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "id"=>"vbad51hh"}
    end
  end  
  
  describe "#save" do
    it "returns false and records errors on failure (validation)" do
      event = StrataGem::Event.new({}, operator = StrataGem::Operator.new("app_id", "secret", "token"))
      operator.stub_chain(:connection, :request).and_return([false, {"errors" => "fail"}])
      event.save.should == false
      event.errors.should == "fail"
    end
    
    it "returns false and records errors on failure (invalid record)" do
      event = StrataGem::Event.new({}, operator = StrataGem::Operator.new("app_id", "secret", "token"))
      operator.stub_chain(:connection, :request).and_return([false, {"error" => "fail"}])
      event.save.should == false
      event.errors.should == "fail"
    end
    
    it "updates the id on success" do
      event = StrataGem::Event.new({}, operator = StrataGem::Operator.new("app_id", "secret", "token"))
      operator.stub_chain(:connection, :request).and_return([true, {"id" => "lala"}])
      event.save.should == true
      event.id == "lala"
    end
  end  
  
  describe "#destroy" do
    it "returns false on fail" do
      event = StrataGem::Event.new({}, operator = StrataGem::Operator.new("app_id", "secret", "token"))
      operator.stub_chain(:connection, :request).and_return(false)
      event.destroy.should == false
    end
    it "returns true on success" do
      event = StrataGem::Event.new({}, operator = StrataGem::Operator.new("app_id", "secret", "token"))
      operator.stub_chain(:connection, :request).and_return(true)
      event.destroy.should == true
    end
  end  
end