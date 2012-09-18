module StrataGem
  class Event
    attr_reader   :id, :operator, :errors
    attr_accessor :departure_time, :arrival_time, :from_airfield_id, :to_airfield_id, :aircraft_id, :utilization, :utilization_count
    
    def initialize(event_hash, operator)
      raise ArgumentError, "Invalid operator specified" if !operator.is_a?(StrataGem::Operator)
      @operator = operator
      @departure_time = event_hash["departure_time"]
      @arrival_time = event_hash["arrival_time"]
      @from_airfield_id = event_hash["from_airfield_id"]
      @to_airfield_id = event_hash["to_airfield_id"]
      @aircraft_id = event_hash["aircraft_id"]
      @utilization = event_hash["utilization"]
      @utilization_count = event_hash["utilization_count"]
      @id = event_hash["id"]
    end
    
    def to_send
      hash = {}
      (instance_variables - [:@operator, :@errors]).each do |iv|
        hash[iv.to_s[1..-1].to_s] = instance_variable_get(iv)
      end
      return hash
    end
    
    def save
      reponse, data = @operator.connection.request((@id.nil? ? :create : :update), {:event => to_send})
      if reponse
        @id = data["id"]
        @errors = nil
        return true
      else
        @errors = data["errors"] || data["error"]
        return false
      end
    end
    
    def destroy
      return @operator.connection.request(:destroy, {:event => to_send})
    end
  end
end