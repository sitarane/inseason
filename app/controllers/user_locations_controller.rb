class UserLocationsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :authorize_user_location

  def update
    location = Geocoder.search(params[:location]).first
    respond_to do |format|
      if location
        # current_user.update(location: location) if current_user
        session[:location] = location_hash(location)
        format.html { redirect_back_or_to root_path }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  private

  def authorize_user_location
    authorize :user_location
  end
end
