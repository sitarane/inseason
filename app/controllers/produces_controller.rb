class ProducesController < ApplicationController
  before_action :set_produce, only: %i[ show edit update destroy ]
  before_action :set_wiki_client, only: %i[new]
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
    if params[:name]
      wiki_page = @wiki_client.find(params[:name])
      @produce = Produce.new(name: wiki_page.title)
      @produce.links.wikipedia.new(url: wiki_page.fullurl)
      @image_url = wiki_page.main_image_url
      other_languages = I18n.available_locales - [I18n.locale]
      if wiki_page.langlinks
        other_languages.each do |language|
          session[:"wikiname_#{language}"] = wiki_page.langlinks[language.to_s]
        end
      end
    else
      @produce = Produce.new
      @produce.links.wikipedia.new
    end
  end

  # GET /produces/1/edit
  def edit
  end

  # POST /produces or /produces.json
  def create
    @produce = Produce.new(produce_params.except(:wiki_image))

    if produce_params[:wiki_image].present? && produce_params[:picture].blank?
      @produce.picture.attach(
        io: URI.parse(produce_params[:wiki_image]).open,
        filename: produce_params[:wiki_image]
      )
    end

    other_languages = I18n.available_locales - [I18n.locale]

    other_languages.each do |language|
      next unless session[:"wikiname_#{language}"]
      wiki_config = Wikipedia::Configuration.new(domain: "#{language}.wikipedia.org")
      wiki_client = Wikipedia::Client.new(wiki_config)
      wiki_page = wiki_client.find(session[:"wikiname_#{language}"])
      Mobility.with_locale(language) do
        @produce.name = wiki_page.title
        @produce.links.first.url = wiki_page.fullurl
      end
    end

    respond_to do |format|
      if @produce.save
        format.html { redirect_to produce_url(@produce), notice: t('.notice') }
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
        format.html { redirect_to produce_url(@produce), notice: t('.notice') }
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
      format.html { redirect_to produces_url, notice: t('.notice') }
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

  def set_wiki_client
    @wiki_client = Wikipedia::Client.new(
      Wikipedia::Configuration.new(domain: "#{I18n.locale}.wikipedia.org")
    )
  end

  # Only allow a list of trusted parameters through.
  def produce_params
    params.require(:produce).permit(
      :name,
      :picture,
      :user_id,
      :wiki_image,
      links_attributes: [:id, :from, :url]
    )
  end
end
