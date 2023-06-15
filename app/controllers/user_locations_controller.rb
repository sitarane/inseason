class UserLocationsController < ApplicationController
  skip_before_action :authenticate_user!

  def update
    location = Geocoder.search(params[:location]).first
    respond_to do |format|
      if location
        # current_uset.update(location: location) if current_user
        session[:location] = location.display_name
        format.html { redirect_to user_location_path }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end
end
