# frozen_string_literal: true

class ForecastsController < ApplicationController
  def index
    @location = ""
    @forecast = nil
    @error_messages = nil

    if params[:location].present?
      forecast = Weather::Forecast.get_forecast(params[:location])
      if forecast[:status] == 404
        @error_messages = forecast[:error]
      else
        @forecast = forecast
      end
    end
  end
end
