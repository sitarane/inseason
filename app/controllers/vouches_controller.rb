class VouchesController < ApplicationController
  before_action :load_season, only: :create
  before_action :load_vouch, only: :update
  before_action :authorize_vouch, except: :create



  def create
    @vouch = @season.vouches.new(vouch_params)
    authorize @vouch
    respond_to do |format|
      if @vouch.save
        format.html { redirect_to produce_url(@season.produce) }
        format.json { render :show, status: :created, location: @vouch }
      else
        format.html { redirect_to produces_url(@season.produce), status: :unprocessable_entity, alert: 'Vouch failed.' }
        format.json { render json: @vouch.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @vouch.update(vouch_params)
        format.html { redirect_to produce_url(@vouch.season.produce) }
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

  def authorize_vouch
    authorize @vouch || Vouch
  end

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
