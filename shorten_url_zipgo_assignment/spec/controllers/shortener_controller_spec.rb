require 'rails_helper'

RSpec.describe ShortenersController, type: :controller do

  describe "GET #index" do
    it "assigns a new Shortener instance to @shortener" do
      get :index
      expect(assigns(:shorteners)).to eq(Shortener.all)
    end

    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #original_redirect" do
    before :each do
      @shortener = create(:shortener, url: "google.com")
      @shortener.sanitize
      @shortener.save
    end

    it "assigns the requested url to @shortener" do
      get :original_redirect, params: { shorten_url: @shortener.shorten_url }
      expect(assigns(:shortener)).to eq @shortener
    end
    it "redirects to the sanitized url" do
      get :original_redirect, params: { shorten_url: @shortener.shorten_url }
      expect(response).to redirect_to(@shortener.sanitized_url)
    end
    it "has a 302 status code" do
      get :original_redirect, params: { shorten_url: @shortener.shorten_url }
      expect(response.status).to eq(302)
    end
  end

  describe "GET #show" do
    before :each do
      @shortener = create(:shortener, url: "google.com")
      @shortener.sanitize
      @shortener.save
    end

    it "assigns the requested url to @shortener" do
      get :show, params: { id: @shortener.id }
      expect(assigns(:shortener)).to eq @shortener
    end

    it "has a 200 status code" do
      get :show, params: { id: @shortener.id }
      expect(response.status).to eq(200)
    end
  end

  describe "GET #fetch_original_url" do
    before :each do
      @shortener = create(:shortener, url: "google.com")
      @shortener.sanitize
      @shortener.save
    end

    it "has a 200 status code" do
      get :fetch_original_url, params: { shorten_url: @shortener.shorten_url }
      expect(response.status).to eq(200)
    end
  end

end
