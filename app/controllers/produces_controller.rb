class ProducesController < ApplicationController
  before_action :set_produce, only: %i[ show edit update destroy ]

  # GET /produces or /produces.json
  def index
    @produces = Produce.all
  end

  # GET /produces/1 or /produces/1.json
  def show
  end

  # GET /produces/new
  def new
    @produce = Produce.new
  end

  # GET /produces/1/edit
  def edit
  end

  # POST /produces or /produces.json
  def create
    @produce = Produce.new(produce_params.except(:wikipedia_link))

    if produce_params[:wikipedia_link].present?
      @produce.links.new(from: :wikipedia, url: produce_params[:wikipedia_link])
    end

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

    if produce_params[:wikipedia_link]
      if @produce.links.wikipedia.any?
        @produce.links.wikipedia.first.update(url: produce_params[:wikipedia_link])
      else
        @produce.links.new(from: :wikipedia, url: produce_params[:wikipedia_link])
      end
    end

    respond_to do |format|
      if @produce.update(produce_params.except(:wikipedia_link))
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
      params.require(:produce).permit(:name, :picture, :wikipedia_link)
    end
end
