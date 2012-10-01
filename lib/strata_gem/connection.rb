module StrataGem
  class Connection
    TESTBED_HOST = "http://testbed.stratafleet.com/"
    PRODUCTION_HOST = "http://api.stratafleet.com/"
    EVENTS_URL = "/events/"
    
    def initialize(application_id, secret, user_token, production = false)
      @token = user_token
      @client = OAuth2::Client.new(application_id, secret, site: (production ? PRODUCTION_HOST : TESTBED_HOST))
      @access = OAuth2::AccessToken.new(@client, user_token, {:refresh_token => user_token})
      @production = production
    end
    
    def inspect
      "<#{self.class.to_s} | Connected to: #{@production ? PRODUCTION_HOST : TESTBED_HOST}>"
    end
    
    
    def request(method, o = {})
      begin 
        case method
        when :show
          return @access.get("#{EVENTS_URL}#{o[:id]}").parsed
        when :show_by_origin
          return @access.get("#{EVENTS_URL}by_origin/#{o[:id]}").parsed
          
        when :index
          return @access.get(EVENTS_URL).parsed
        when :index_by_aircraft
          return @access.get("/aircrafts/#{o[:aircraft_id]}/events").parsed
          
          
        when :create
          return [true, @access.post("#{EVENTS_URL}", :params => o).parsed]
        when :create_in_batch
          @access.post("#{EVENTS_URL}batch", :params => o)
          return true
          
        when :update
          data = @access.put("#{EVENTS_URL}#{o[:event]["id"]}", :params => o).parsed
          return [true, {"id" => data["id"]}]
          
          
        when :destroy
          @access.delete("#{EVENTS_URL}#{o[:event]["id"]}")
          return true
          
          
        end
      rescue OAuth2::Error => e
        case e.response.status
        when 401 #invalid token
          raise InvalidToken, "Token is invalid or has expired"
        when 422 #invalid object
          case method
          when :update, :create
            return [false, JSON.parse(e.response.body)]
          when :create_in_batch
            return false
          when :destroy, :show, :show_by_origin
            return false
          end
        end
      end
    end
  end
end