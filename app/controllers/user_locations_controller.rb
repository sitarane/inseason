class UserLocationsController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @state = current_location
  end

  def update
    location = Geocoder.search(params[:location]).first
    respond_to do |format|
      if location
        # current_uset.update(location: location) if current_user
        session[:location] = location.display_name
        format.html { redirect_to user_location_path, notice: "Location was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  # def location_params
  #   params.permit(:location)
  # end
end
