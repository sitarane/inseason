class VouchesController < ApplicationController
  before_action :load_season, only: :create
  before_action :load_vouch, only: %i(show update)

  def show
  end

  def create
    @vouch = @season.vouches.new(vouch_params)
    respond_to do |format|
      if @vouch.save
        format.html { redirect_to produces_url(@season.produce), notice: "Vouch was successfully created." }
        #format.json { render :show, status: :created, location: @vouch } # There's no #show
      else
        format.html { redirect_to produces_url(@season.produce), status: :unprocessable_entity }
        format.json { render json: @vouch.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vouch.update(vouch_params)
        format.html { redirect_to produce_url(@vouch.season.produce), notice: "Vouch was successfully updated." }
        format.json { render :show, status: :ok, location: @vouch }
      else
        format.html { redirect_to produce_url(@vouch.season.produce),
          status: :unprocessable_entity,
          alert: 'Failed to update vouch.'}
        format.json { render json: @vouch.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def load_vouch
    @vouch = Vouch.find(params[:id])
  end

  def load_season
    @season = Season.find(vouch_params[:season_id])
  end

  def vouch_params
    params.require(:vouch).permit(:user_id, :season_id, :value)
  end
end
