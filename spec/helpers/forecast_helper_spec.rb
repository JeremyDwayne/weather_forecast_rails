# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ForecastHelper, type: :helper) do
  describe "#display_location" do
    it "returns display name if present" do
      forecast = { "display_name" => "New York, NY" }
      expect(helper.display_location(forecast)).to(eq("New York, NY"))
    end

    it "returns address if display name not present" do
      forecast = { "address" => "12345" }
      expect(helper.display_location(forecast)).to(eq("12345"))
    end
  end

  describe "#current_temperature" do
    it "returns formatted current temperature" do
      forecast = { "current" => { "temperature_2m" => 75 }, "current_units" => { "temperature_2m" => "°F" } }
      expect(helper.current_temperature(forecast)).to(eq("75°F"))
    end
  end

  describe "#forecast_min_temperature" do
    it "returns formatted min temperature" do
      forecast = { "daily" => { "temperature_2m_min" => [70, 60] }, "daily_units" => { "temperature_2m_min" => "°F" } }
      expect(helper.forecast_min_temperature(forecast, 0)).to(eq("70°F"))
      expect(helper.forecast_min_temperature(forecast, 1)).to(eq("60°F"))
    end
  end

  describe "#forecast_max_temperature" do
    it "returns formatted max temperature" do
      forecast = { "daily" => { "temperature_2m_max" => [70, 60] }, "daily_units" => { "temperature_2m_max" => "°F" } }
      expect(helper.forecast_max_temperature(forecast, 0)).to(eq("70°F"))
      expect(helper.forecast_max_temperature(forecast, 1)).to(eq("60°F"))
    end
  end
end
