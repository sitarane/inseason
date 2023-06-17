class ProducesController < ApplicationController
  before_action :set_produce, only: %i[ show edit update destroy ]

  # GET /produces or /produces.json
  def index
    @produces = Produce.all
  end

  # GET /produces/1 or /produces/1.json
  def show
    # Change this to nearby
    @season = @produce.seasons.first
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
  def set_produce
    @produce = Produce.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def produce_params
    params.require(:produce).permit(:name, :picture, links_attributes: [:id, :from, :url])
  end
end
