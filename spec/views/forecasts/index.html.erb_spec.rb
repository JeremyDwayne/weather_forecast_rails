# frozen_string_literal: true

require "rails_helper"

RSpec.describe("forecasts/index", type: :view) do
  it "renders forecast details" do
    forecast = {
      "display_name" => "New York",
      "cached" => true,
      "current" => { "temperature_2m" => 75 },
      "current_units" => { "temperature_2m" => "°F" },
      "daily_units" => { "temperature_2m_min" => "°F", temperature_2m_max: "°F" },
      "daily" => {
        "time" => ["2024-02-19", "2024-02-20"],
        "temperature_2m_min" => [50, 55],
        "temperature_2m_max" => [80, 85],
      },
    }
    assign(:forecast, forecast)

    render

    expect(rendered).to(have_css("h2", text: "Forecast For: New York"))
    expect(rendered).to(have_css(".cached-indicator"))
    expect(rendered).to(have_css(".current-temperature", text: "Current Temperature: 75°F"))
    expect(rendered).to(have_css(".forecast-day", count: 2))
  end
end
