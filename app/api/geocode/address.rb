# frozen_string_literal: true

module Geocode
  class Address
    require "net/http"
    API_ENDPOINT = "https://geocode.maps.co/search?"

    class << self
      def coordinates(address)
        params = { q: address, api_key: Rails.application.credentials.geocode_api_key }
        uri = URI(API_ENDPOINT)
        uri.query = URI.encode_www_form(params)
        response = Net::HTTP.get_response(uri)

        # For simplicity I'm returning the first result
        # I would need to handle multiple results and let the user choose the correct one
        # Likely with a real time search hitting the map API
        location = JSON.parse(response.body)[0]
        return Net::HTTPNotFound if location.nil?

        [location["lat"], location["lon"]]
      end
    end
  end
end
