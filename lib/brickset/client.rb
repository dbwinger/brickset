require "httparty"

module Brickset
  class Client
    include HTTParty

    # Define the same set of accessors as the Awesome module
    attr_accessor *Configuration::VALID_CONFIG_KEYS
    
    def initialize(options = {})
      # Merge the config values from the module and those passed
      # to the client.
      merged_options = Brickset.options.merge(options)

      # Copy the merged values to this client and ignore those
      # not part of our configuration
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def get_sets options = {}
      required_params = [:userHash, :query, :theme, :subtheme, :setNumber, :year, :owned, :wanted, :orderBy, :pageSize, :pageNumber, :userName]
      default_options = {}
      required_params.each { |param| default_options[param] = nil }
      response = call_api(:getSets, default_options.merge(options))
      if response["ArrayOfSets"].nil?
        []
      else
        response["ArrayOfSets"]["sets"] 
      end
    end

    def get_recently_updated_sets minutes_ago
      response = call_api :getRecentlyUpdatedSets, { minutesAgo: minutes_ago }
      if response["ArrayOfSets"].nil?
        []
      else
        response["ArrayOfSets"]["sets"] 
      end
    end

    protected

    def call_api method, options = {}
      response = self.class.get("#{endpoint}/#{method.to_s}", query: options.merge(apiKey: api_key))
      if response.code == 200
        response.parsed_response
      else
        raise response.body
      end
    end
  end
end