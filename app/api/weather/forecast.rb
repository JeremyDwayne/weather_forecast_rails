# frozen_string_literal: true

require "net/http"
require "json"
require "geocoder"

module Weather
  class LocationNotFound < StandardError; end

  class Forecast
    API_VERSION = "v1"
    API_URL = "https://api.open-meteo.com/#{API_VERSION}"
    ENDPOINT_URL = "#{API_URL}/forecast"

    class << self
      def get_forecast(address)
        forecast = fetch_forecast_from_cache(address)
        if forecast
          forecast["cached"] = true
          return forecast
        end

        lat, long, display_name = get_location(address)
        forecast = fetch_forecast(lat, long)
        forecast["display_name"] = display_name.split(",")[0]
        forecast["address"] = address
        forecast["cached"] = false

        write_to_cache(address, forecast)
        forecast
      rescue LocationNotFound => e
        { status: 404, error: e.message }
      end

      private

      def fetch_forecast_from_cache(address)
        Rails.cache.fetch(address)
      end

      def write_to_cache(address, forecast)
        Rails.cache.write(address, forecast, expires_in: 30.minutes)
      end

      def fetch_forecast(lat, long)
        params = {
          latitude: lat,
          longitude: long,
          forecast_days: 4,
          temperature_unit: "fahrenheit",
          current: "temperature_2m",
          daily: "temperature_2m_min,temperature_2m_max",
        }

        uri = URI(ENDPOINT_URL)
        uri.query = URI.encode_www_form(params)

        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
      end

      def get_location(address)
        location = Geocoder.search(address)
        raise LocationNotFound, "Could not find location: #{address}" if location.empty?

        location.first.coordinates << location.first.display_name
      end
    end
  end
end
