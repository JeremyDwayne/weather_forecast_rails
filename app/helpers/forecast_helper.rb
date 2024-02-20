# frozen_string_literal: true

module ForecastHelper
  def display_location(forecast)
    forecast["display_name"] || forecast["address"]
  end

  def formatted_date(day)
    Time.parse(day).strftime("%a, %b %d")
  end

  def current_temperature(forecast)
    "#{forecast["current"]["temperature_2m"]}#{forecast["current_units"]["temperature_2m"]}"
  end

  def forecast_min_temperature(forecast, index)
    "#{forecast["daily"]["temperature_2m_min"][index]}#{forecast["daily_units"]["temperature_2m_min"]}"
  end

  def forecast_max_temperature(forecast, index)
    "#{forecast["daily"]["temperature_2m_max"][index]}#{forecast["daily_units"]["temperature_2m_max"]}"
  end
end
