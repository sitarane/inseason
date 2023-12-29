class ApplicationController < ActionController::Base
  include Pundit::Authorization
  after_action :verify_authorized, unless: :devise_controller?
  # after_action :verify_policy_scoped, only: :index

  before_action :authenticate_user!, except: %i[ show index ]
  before_action :load_location

  around_action :switch_locale

  private

  def switch_locale(&action)
    locale = params[:locale] || browser_language || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def browser_language
    return nil if Rails.env.test?
    (extract_locales_from_accept_language_header & I18n.available_locales).first
  end

  def extract_locales_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).map(&:to_sym)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def current_location
    session[:location].presence || set_location_from_ip
  end

  def set_location_from_ip
    if Rails.env.development?
      location = nil #Geocoder.search("Leipzig, Germany").first
    else
      location = request.location
    end
    return nil unless location
    session[:location] = location_hash(location)
  end

  def location_hash(location)
    {
      latitude: location.latitude,
      longitude: location.longitude,
      state: location.state,
      country: location.country,
      display_name: location.try(:display_name)
    }
  end

  def load_location
    return "Undefined" unless current_location
    current_location.transform_keys!(&:to_sym)
    if current_location[:state] && current_location[:country]
      @location = "#{current_location[:state]}, #{current_location[:country]}"
    elsif current_location[:display_name]
      @location = current_location[:display_name]
    else
      @location = current_location[:latitude].to_f.round(1).to_s + ", " + current_location[:longitude].to_f.round(1).to_s
    end
  end
end
