class ProducesController < ApplicationController
  before_action :set_produce, only: %i[ show edit update destroy ]
  before_action :authorize_produce

  # GET /produces or /produces.json
  def index
    # TODO Limit these
    @in_season_produces = Produce.order("RANDOM()").in_season(
      current_location[:latitude],
      current_location[:longitude]
    )

    @unknow_season_produce = Produce.order("RANDOM()").season_unknown(
      current_location[:latitude],
      current_location[:longitude]
    )

    if params[:query].present?
      @other_produces = Produce.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
    else
      @other_produces = Produce.order("RANDOM()").limit(20) - @in_season_produces - @unknow_season_produce
    end
  end

  # GET /produces/1 or /produces/1.json
  def show
    coordinates = [current_location[:latitude], current_location[:longitude]]
    @season = @produce.seasons.near(coordinates, 500).first
    @latitude = current_location[:latitude].to_s
    @longitude = current_location[:longitude].to_s
    if @season
      @season_distance = @season.distance_to(coordinates).round
      @vouch = @season.vouches.find_by(user: current_user)
    end
  end

  # GET /produces/new
  def new
    @produce = Produce.new
    @produce.links.wikipedia.new
  end

  # GET /produces/1/edit
  def edit
  end

  # POST /produces or /produces.json
  def create
    @produce = Produce.new(produce_params)

    respond_to do |format|
      if @produce.save
        format.html { redirect_to produce_url(@produce), notice: "Produce was successfully created." }
        format.json { render :show, status: :created, location: @produce }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @produce.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /produces/1 or /produces/1.json
  def update
    respond_to do |format|
      if @produce.update(produce_params)
        format.html { redirect_to produce_url(@produce), notice: "Produce was successfully updated." }
        format.json { render :show, status: :ok, location: @produce }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @produce.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /produces/1 or /produces/1.json
  def destroy
    @produce.destroy

    respond_to do |format|
      format.html { redirect_to produces_url, notice: "Produce was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.

  def authorize_produce
    authorize @produce || Produce
  end

  def set_produce
    @produce = Produce.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def produce_params
    params.require(:produce).permit(
      :name,
      :picture,
      :user_id,
      links_attributes: [:id, :from, :url]
    )
  end
end
