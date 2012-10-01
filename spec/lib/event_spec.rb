require 'spec_helper'
describe StrataGem::Operator do
  
  describe "#initialize" do
    it "stores the data ad allows it to be retrieved" do
      event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {"start_time"=>"2012-01-01T01:00:00Z", "end_time"=>"2012-01-01T02:00:00Z", "start_airfield"=>"egll", "end_airfield"=>"eglc", "aircraft_registration"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "deleted"=>1, "data_source"=>"Strata", "data_source_unique_id"=>123, "id"=>"vbad51hh"})
      event.start_time.should == "2012-01-01T01:00:00Z"
      event.end_time.should == "2012-01-01T02:00:00Z"
      event.start_airfield.should == "egll"
      event.end_airfield.should == "eglc"
      event.utilization.should == "PAX"
      event.utilization_count.should == 2
      event.aircraft_registration.should == "g-alex"
      event.id.should == "vbad51hh"
      event.operator.should == operator
      event.deleted.should == 1
      event.data_source.should == "Strata"
      event.data_source_unique_id.should == 123
    end
    
    it "raises an exception if an operator is not provided" do
      expect {StrataGem::Event.new(nil, {})}.to raise_error(StrataGem::ArgumentError)
    end
    
  end
  
  describe "#to_send" do
    it "creates a hash of the attributes" do
      event = StrataGem::Event.new(StrataGem::Operator.new("app_id", "secret", "token"), {"start_time"=>"2012-01-01T01:00:00Z", "end_time"=>"2012-01-01T02:00:00Z", "start_airfield"=>"egll", "end_airfield"=>"eglc", "aircraft_registration"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "deleted"=>1, "data_source"=>"Strata", "data_source_unique_id"=>123, "id"=>"vbad51hh"})
      event.to_send.should == {"start_time"=>"2012-01-01T01:00:00Z", "end_time"=>"2012-01-01T02:00:00Z", "start_airfield"=>"egll", "end_airfield"=>"eglc", "aircraft_registration"=>"g-alex", "utilization"=>"PAX", "utilization_count"=>2, "deleted"=>1, "data_source"=>"Strata", "data_source_unique_id"=>123, "id"=>"vbad51hh"}
    end
  end  
  
  describe "#save" do
    it "returns false and records errors on failure (validation)" do
      event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {})
      operator.stub_chain(:connection, :request).and_return([false, {"errors" => "fail"}])
      event.save.should == false
      event.errors.should == "fail"
    end
    
    it "returns false and records errors on failure (invalid record)" do
      event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {})
      operator.stub_chain(:connection, :request).and_return([false, {"error" => "fail"}])
      event.save.should == false
      event.errors.should == "fail"
    end
    
    it "updates the id on success" do
      event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {})
      operator.stub_chain(:connection, :request).and_return([true, {"id" => "lala"}])
      event.save.should == true
      event.id == "lala"
    end
  end  
  
  describe "#destroy" do
    it "returns false on fail" do
      event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {})
      operator.stub_chain(:connection, :request).and_return(false)
      event.destroy.should == false
    end
    it "returns true on success" do
      event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {})
      operator.stub_chain(:connection, :request).and_return(true)
      event.destroy.should == true
    end
  end  
end