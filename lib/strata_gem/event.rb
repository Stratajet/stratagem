module StrataGem
  class Event
    attr_reader   :id, :operator, :errors
    attr_accessor :start_time, :end_time, :start_airfield, :end_airfield, :aircraft_registration, :utilization, :utilization_count, :deleted, :data_source, :data_source_unique_id
    
    def initialize(operator, event_hash = {})
      raise ArgumentError, "Invalid operator specified" if !operator.is_a?(StrataGem::Operator)
      @operator = operator
      @start_time = event_hash["start_time"]
      @end_time = event_hash["end_time"]
      @start_airfield = event_hash["start_airfield"]
      @end_airfield = event_hash["end_airfield"]
      @aircraft_registration = event_hash["aircraft_registration"]
      @utilization = event_hash["utilization"]
      @utilization_count = event_hash["utilization_count"]
      @deleted = event_hash["deleted"]
      @data_source = event_hash["data_source"]
      @data_source_unique_id = event_hash["data_source_unique_id"]
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
    
    def inspect
      "<#{self.class.to_s} | #{@id}>"
    end
    
    def destroy
      return @operator.connection.request(:destroy, {:event => to_send})
    end
  end
end