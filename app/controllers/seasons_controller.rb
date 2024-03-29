class SeasonsController < ApplicationController
  before_action :set_season, only: %i[ show update destroy ]
  before_action :set_produce, only: :create
  before_action :authorize_season

  # GET /seasons/1 or /seasons/1.json
  def show
  end

  # POST /seasons or /seasons.json
  def create
    @season = @produce.seasons.new(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to produce_path(@produce) }
        format.json { render :show, status: :created, location: @season }
      else
        format.html { redirect_to produce_path(@produce), status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1 or /seasons/1.json
  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to season_path(@season), notice: "Season was successfully updated." }
        format.json { render :show, status: :ok, location: @season }
      else
        format.html { redirect_to season_path(@season), status: :unprocessable_entity }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1 or /seasons/1.json
  def destroy
    @season.destroy

    respond_to do |format|
      format.html { redirect_to produces_url(@produce), notice: "Season was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def authorize_season
      authorize @season || Season
    end
    def set_season
      @season = Season.find(params[:id])
    end

    def set_produce
      @produce = Produce.friendly.find(params[:produce_id])
    end

    # Only allow a list of trusted parameters through.
    def season_params
      params.require(:season).permit(
        :latitude,
        :longitude,
        :place,
        :produce_id,
        :user_id,
        :start_time,
        :end_time
      )
    end
end
