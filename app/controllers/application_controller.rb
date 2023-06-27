class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index

  before_action :authenticate_user!, except: %i[ show index ]
  before_action :load_location

  private

  def current_location
    session[:location].presence || set_location_from_ip
  end

  def set_location_from_ip
    if Rails.env.development?
      location = Geocoder.search("Leipzig, Germany").first
    else
      location = request.location
    end
    session[:location] = location_hash(location)
  end

  def location_hash(location)
    {
      latitude: location.latitude,
      longitude: location.longitude,
      state: location.state,
      country: location.country,
      display_name: location.display_name
    }
  end

  def load_location
    current_location.transform_keys!(&:to_sym)
    if current_location[:state] && current_location[:country]
      @location = "#{current_location[:state]}, #{current_location[:country]}"
    else
      @location = current_location[:display_name]
    end
  end
end
