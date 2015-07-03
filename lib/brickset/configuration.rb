module Brickset
  module Configuration
    VALID_CONNECTION_KEYS = [:endpoint, :user_agent, :method].freeze
    VALID_OPTIONS_KEYS    = [:api_key].freeze
    VALID_CONFIG_KEYS     = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS
 
    DEFAULT_ENDPOINT    = 'http://brickset.com/api/v2.asmx'
    DEFAULT_METHOD      = :get
    DEFAULT_USER_AGENT  = "Brickset API Ruby Gem #{Brickset::VERSION}".freeze
    DEFAULT_API_KEY     = "TuKn-uq37-Ppq2"
 
    # Build accessor methods for every config options so we can do this, for example:
    #   Awesome.method = :get
    attr_accessor *VALID_CONFIG_KEYS

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end
 
    def reset
      self.endpoint   = DEFAULT_ENDPOINT
      self.method     = DEFAULT_METHOD
      self.user_agent = DEFAULT_USER_AGENT
 
      self.api_key    = DEFAULT_API_KEY
    end

    def configure
      yield self
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end
  end
end