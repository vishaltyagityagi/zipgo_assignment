class ShortenersController < ApplicationController
  before_action :set_shortener, only: [:show, :edit, :update, :destroy]

  def index
   index_data
  end

  def show
    if @shortener.present?
      render json: @shortener and return unless request.format.html?
    else
      render :json => { :errors => "Shortner doesn't exists with this id" }
    end
  end

  def original_redirect
    @shortener = Shortener.find_by_shorten_url(params['shorten_url'])
    redirect_to @shortener.sanitized_url
  end
  def new
    @shortener = Shortener.new
  end

  def edit
  end

  def fetch_original_url
    @shortner = Shortener.find_by_shorten_url(params['shorten_url'].gsub("#{request.base_url}/", ''))
    if @shortner.present?
      render json: {original_url: @shortner.url}
    else
      render :json => { :errors => "Shorten Url doesn't exists" }
    end
  end

  def import
   importt(params[:file])
   redirect_to root_url, notice: "Products imported."

  end

def importt(file)
  
  if file.present?
    CSV.foreach(file.path) do |row|
    # Shortener.create! row.to_hash

      row.each do |r|
      @shortener = Shortener.new(url: r)
      @shortener.sanitize
      # respond_to do |format|
      if @shortener.new_url?
        @shortener.save
      end
      end
    end
  end
end

  def create
    @shortener = Shortener.new(shortener_params)
    @shortener.sanitize
    respond_to do |format|
      if @shortener.new_url?
        if @shortener.save
          format.html { redirect_to @shortener, notice: 'Shortener was successfully created.' }
          format.json { render :show, status: :created, location: @shortener }
        else
          format.html { render :new }
          format.json { render json: @shortener.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to @shortener, notice: 'Shortener was already there.' }
      end
    end
  end

  def update
    respond_to do |format|
      if @shortener.update(shortener_params)
        format.html { redirect_to @shortener, notice: 'Shortener was successfully updated.' }
        format.json { render :show, status: :ok, location: @shortener }
      else
        format.html { render :edit }
        format.json { render json: @shortener.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @shortener.present?
      @shortener.destroy
      respond_to do |format|
        format.html { redirect_to shorteners_url, notice: 'Shortener was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      render :json => { :errors => "Shortner doesn't exists with this id" }
    end
  end

  private

    def index_data
      @shorteners = Shortener.all
      render json: @shorteners and return unless request.format.html?
    end
    def set_shortener
      @shortener = Shortener.where(id: params[:id]).last
    end

    def shortener_params
      params.require(:shortener).permit(:url, :shorten_url, :sanitized_url)
    end
end
