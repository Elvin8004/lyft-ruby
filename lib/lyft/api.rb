module Lyft
  class API

    attr_accessor :access_token

    def initialize(access_token=nil)
      access_token = parse_access_token(access_token)
      verify_access_token!(access_token)
      @access_token = access_token

      @connection = Lyft::Connection.new params: default_params,
                                             headers: default_headers

      initialize_endpoints
    end

    extend Forwardable # Composition over inheritance
    def_delegators :@rides, :rides

    private ##############################################################

    def initialize_endpoints
      @rides = Lyft::Rides.new(@connection)
    end

    def default_params
      return {oauth2_access_token: @access_token.token}
    end

    def default_headers
      return {"x-li-format" => "json"}
    end

    def verify_access_token!(access_token)
      if not access_token.is_a? Lyft::AccessToken
        raise no_access_token_error
      end
    end

    def parse_access_token(access_token)
      if access_token.is_a? Lyft::AccessToken
        return access_token
      elsif access_token.is_a? String
        return Lyft::AccessToken.new(access_token)
      end
    end

    def no_access_token_error
      msg = Lyft::ErrorMessages.no_access_token
      Lyft::InvalidRequest.new(msg)
    end
  end
end
