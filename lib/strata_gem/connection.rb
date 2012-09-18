module StrataGem
  class Connection
    TESTBED_HOST = "http://testbed.stratafleet.com/"
    PRODUCTION_HOST = "http://testbed.stratafleet.com/"
    EVENTS_URL = "/events/"
    
    def initialize(application_id, secret, user_token, production = false)
      @token = user_token
      @client = OAuth2::Client.new(application_id, secret, site: (production ? PRODUCTION_HOST : TESTBED_HOST))
      @access = OAuth2::AccessToken.new(@client, user_token, {:refresh_token => user_token})
    end
    
    def request(method, o = {})
      begin 
        case method
        when :show
          return @access.get("#{EVENTS_URL}#{o[:id]}").parsed
        when :index
          return @access.get(EVENTS_URL).parsed
        when :create
          return [true, @access.post("#{EVENTS_URL}", :params => o).parsed]
        when :update
          @access.put("#{EVENTS_URL}#{o[:event]["id"]}", :params => o).parsed
          return [true, {"id" => o[:id]}]
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
          when :destroy, :show
            return false
          end
        end
      end
    end
  end
end