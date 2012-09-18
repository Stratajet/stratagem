module StrataGem

  # The starting point of making a connection to Stratajet
  class Operator
    attr_reader :connection
    
    # Creates the initial conncetion to Stratajet and facilitates additional calls to the Stratajet servers.
    # Test applications can be set-up on http://developers.stratajet.com
    #
    # Example
    #    >> StrataGem::Operator.new("d748b...", "ac48a...", "983c3...")
    #
    def initialize(application_id, secret, user_token, production = false)
      @connection = Connection.new(application_id, secret, user_token, production)
    end


    # Pulls a list of all aircraft events currently stored on Stratajet's servers and creates an Event model for each of them
    #
    #
    def index
      @connection.request(:index).map { |e| Event.new(e, self) }
    end


    # Pulls a particular aircraft event using the id of a particular event
    #
    #
    def get(id)
      Event.new(@connection.request(:show, {:id => id}), self)
    end
        
  end
end