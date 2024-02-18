# frozen_string_literal: true

module Weather
  class Forecast
    BASE_URL = "https://api.open-meteo.com/"
    VERSION = "v1"
    class << self
      def get(address)
        lat, long = Geocode::Address.coordinates(address)
        params = {
          latitude: lat,
          longitude: long,
          forecast_days: 10,
          temperature_unit: "fahrenheit",
          current: "temperature_2m",
          daily: "temperature_2m_min,temperature_2m_max",
        }

        uri = URI("#{BASE_URL}#{VERSION}/forecast")
        uri.query = URI.encode_www_form(params)

        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)
      end
    end
  end
end
