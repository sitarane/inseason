class ApplicationController < ActionController::Base
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
    session[:location] = location.display_name
  end

  def load_location
    @state = current_location
  end
end
