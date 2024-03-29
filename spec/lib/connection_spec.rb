require 'spec_helper'
describe StrataGem::Connection do
  
  describe "#initialize" do
    it "stores the token and creates an OAuth client and access" do
      connection = StrataGem::Connection.new("app_id", "secret", "token")
      connection.instance_eval do
        @token.should == "token"
        @client.class.should == OAuth2::Client
        @access.class.should == OAuth2::AccessToken
      end
    end
  end


  describe "#request" do
    
    context "correct request format" do
      it "send the right information for a show" do
        operator = StrataGem::Operator.new("app_id", "secret", "token")
        (the_reponse = double("response")).stub(:parsed).and_return({})
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:get).with("/events/lala").and_return(the_reponse) } }
        operator.get("lala")
      end
      
      
      it "send the right information for a show by origin" do
        operator = StrataGem::Operator.new("app_id", "secret", "token")
        (the_reponse = double("response")).stub(:parsed).and_return({})
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:get).with("/events/by_origin/lala").and_return(the_reponse) } }
        operator.get_by_unique("lala")
      end      
      
      it "send the right information for an index by aircraft" do
        operator = StrataGem::Operator.new("app_id", "secret", "token")
        (the_reponse = double("response")).stub(:parsed).and_return({})
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:get).with("/aircrafts/lala/events").and_return(the_reponse) } }
        operator.index_by_aircraft("lala")
      end      
      
      
      it "send the right information for an index" do
        operator = StrataGem::Operator.new("app_id", "secret", "token")
        (the_reponse = double("response")).stub(:parsed).and_return([])
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:get).with("/events/").and_return(the_reponse) } }
        operator.index
      end

      it "send the right information for a create" do
        event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {"start_airfield" => "w00t"})
        (the_reponse = double("response")).stub(:parsed).and_return({})
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:post).with("/events/", {:params=>{:event=>{"start_time"=>nil, "end_time"=>nil, "start_airfield"=>"w00t", "end_airfield"=>nil, "aircraft_registration"=>nil, "utilization"=>nil, "utilization_count"=>nil, "deleted"=>nil, "data_source"=>nil, "data_source_unique_id"=>nil, "id"=>nil}}}).and_return(the_reponse) } }
        event.save
      end
      
      it "send the right information for a batch" do
        event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {"start_airfield" => "w00t"})
        (the_reponse = double("response")).stub(:parsed).and_return({})
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:post).with("/events/batch", {:params=>{:events=>[{"start_time"=>nil, "end_time"=>nil, "start_airfield"=>"w00t", "end_airfield"=>nil, "aircraft_registration"=>nil, "utilization"=>nil, "utilization_count"=>nil, "deleted"=>nil, "data_source"=>nil, "data_source_unique_id"=>nil, "id"=>nil}]}}).and_return(the_reponse) } }
        operator.create_in_batch([event])
      end
      
      it "send the right information for an update" do
        event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {"id" => "abc", "start_airfield" => "w00t"})
        (the_reponse = double("response")).stub(:parsed).and_return({})
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:put).with("/events/abc", {:params=>{:event=>{"start_time"=>nil, "end_time"=>nil, "start_airfield"=>"w00t", "end_airfield"=>nil, "aircraft_registration"=>nil, "utilization"=>nil, "utilization_count"=>nil, "deleted"=>nil, "data_source"=>nil, "data_source_unique_id"=>nil, "id"=>"abc"}}}).and_return(the_reponse) } }
        event.save
      end
      
      it "send the right information for a destroy" do
        event = StrataGem::Event.new(operator = StrataGem::Operator.new("app_id", "secret", "token"), {"id" => "abc", "end_airfield" => "w00t"})
        (the_reponse = double("response")).stub(:parsed).and_return({})
        operator.instance_eval { @connection.instance_eval { @access.should_receive(:delete).with("/events/abc").and_return(the_reponse) } }
        event.destroy
      end

      
    end
    
    context "error handling" do
      it "raises an exception if token is invalid" do
        #sets up the failure
        connection = StrataGem::Connection.new("app_id", "secret", "token")
        connection.instance_eval do
          @access.stub(:get){raise OAuth2::Error, OAuth2::Response.new(Faraday::Response.new({:status => 401, :response_headers => {}}))}
        end
        # connection.request(:index)
        expect {connection.request(:index)}.to raise_error(StrataGem::InvalidToken)
      end
    
    
      ########################################################################################################################
      ## Sending data
      it "returns false and error information for put and post" do
        test_sending_data_error(:update, :put)
        test_sending_data_error(:create, :post)
      end
    
      def test_sending_data_error(command, method)
        #sets up the failure
        connection = StrataGem::Connection.new("app_id", "secret", "token")
        connection.instance_eval do
          @access.stub(method){raise OAuth2::Error, OAuth2::Response.new(Faraday::Response.new({:status => 422, :body => "{\"errors\":{\"arrival_time\":[\"can't be blank\",\"format must be yyyy-mm-ddThh:mm:ssZ\"]}}", :response_headers => {}}))}
        end
        # connection.request(:index)
        response, errors = connection.request(command, {:event => {}})
        response.should == false
        errors.should == {"errors"=>{"arrival_time"=>["can't be blank", "format must be yyyy-mm-ddThh:mm:ssZ"]}}
      end
      ########################################################################################################################
    
    
    
      ########################################################################################################################
      ## Getting data
      it "returns false for get and delete" do
        test_receiving_data_error(:show, :get)
        test_receiving_data_error(:destroy, :delete)
      end

      def test_receiving_data_error(command, method)
        #sets up the failure
        connection = StrataGem::Connection.new("app_id", "secret", "token")
        connection.instance_eval do
          @access.stub(method){raise OAuth2::Error, OAuth2::Response.new(Faraday::Response.new({:status => 422, :response_headers => {}}))}
        end
        # connection.request(:index)
        response = connection.request(command, {:event => {}})
        response.should == false
      end
      ########################################################################################################################
    end
    
  end

end