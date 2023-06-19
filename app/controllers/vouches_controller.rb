class VouchesController < ApplicationController
  before_action :load_season

  def create
    @vouch = @season.vouches.new(vouch_params)
    debugger
    respond_to do |format|
      if @vouch.save
        format.html { redirect_to produces_url(@season.produce), notice: "Vouch was successfully created." }
        #format.json { render :show, status: :created, location: @vouch } # There's no #show
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vouch.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_season
    @season = Season.find(vouch_params[:season_id])
  end

  def vouch_params
    params.require(:vouch).permit(:user_id, :season_id, :value)
  end
end
