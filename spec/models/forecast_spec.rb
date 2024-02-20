# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Weather::Forecast) do
  describe ".get_forecast" do
    context "when forecast is cached" do
      let(:cached_forecast) { { "cached" => true, "temperature" => 75 } }

      before do
        allow(Rails.cache).to(receive(:fetch).and_return(cached_forecast))
      end

      it "returns cached forecast" do
        expect(described_class.get_forecast("New York")).to(eq(cached_forecast))
      end
    end

    context "when forecast is not cached" do
      let(:location) { "New York" }
      let(:lat) { 40.7128 }
      let(:long) { -74.0060 }
      let(:display_name) { "New York" }
      let(:forecast_data) do
        {
          "current" => { "temperature_2m" => 75 },
          "current_units" => { "temperature_2m" => "°F" },
          "daily_units" => { "temperature_2m_min" => "°F", "temperature_2m_max" => "°F" },
          "daily" => {
            "time" => ["2024-02-19", "2024-02-20"],
            "temperature_2m_min" => [50, 55],
            "temperature_2m_max" => [80, 85],
          },
        }
      end

      before do
        allow(Rails.cache).to(receive(:fetch).and_return(nil))
        allow(Geocoder).to(receive(:search).with(location).and_return([double(
          "Location",
          coordinates: [lat, long],
          display_name: display_name,
        )]))
        allow(described_class).to(receive(:fetch_forecast).and_return(forecast_data))
      end

      it "fetches forecast from API" do
        expect(described_class).to(receive(:fetch_forecast).with(lat, long))
        described_class.get_forecast(location)
      end

      it "writes forecast to cache" do
        expected_forecast = forecast_data.merge(
          "address" => "New York",
          "display_name" => "New York",
          "cached" => false,
        )
        expect(Rails.cache).to(receive(:write).with(location, expected_forecast, expires_in: 30.minutes))
        described_class.get_forecast(location)
      end

      it "returns forecast" do
        expect(described_class.get_forecast(location)).to(eq(forecast_data.merge("display_name" => "New York")))
      end
    end

    context "when location not found" do
      before do
        allow(Geocoder).to(receive(:search).and_return([]))
      end

      it "returns 404 error" do
        expect(described_class.get_forecast("Invalid Location")).to(eq({
          status: 404,
          error: "Could not find location: Invalid Location",
        }))
      end
    end
  end
end
