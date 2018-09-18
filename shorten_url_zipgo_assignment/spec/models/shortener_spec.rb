require 'rails_helper'

RSpec.describe Shortener, type: :model do

  it "is valid with a valid shortener" do
    shortener = build(:shortener)
    expect(shortener).to be_valid
  end

  it "is invalid without a url" do
    shortener = build(:shortener, url: nil)
    shortener.valid?
    expect(shortener.errors[:url]).to include("can't be blank", "is invalid")
  end

  it "is invalid with an invalid URL" do
    shortener = build(:shortener, url: "abc")
    shortener.valid?
    expect(shortener.errors[:url]).to include("is invalid")
  end

  describe "method" do

    before :each do
      @url_google = create(:shortener, url: "google.com")
      @url_google.sanitize
      @url_google.save
    end

    it "#generate_short_url generates a 6-char string containing only letters and numbers" do
      shortener = build(:shortener)
      shortener.generate_shorten_url
      expect(shortener.shorten_url).to match(/\A[a-z\d]{6}\z/i)
    end

    it "#find_duplicate finds a duplicate in the database" do
      shortener = build(:shortener, url: "www.google.com")
      shortener.sanitize
      expect(shortener.find_duplicate).to eq(@url_google)
    end

    context "#new_url?" do
      it "returns false if the URL is already present in the database" do
        shortener = build(:shortener, url: "www.google.com")
        shortener.sanitize
        expect(shortener.new_url?).to eq(false)
      end

      it "returns true if the URL is not found in the database" do
        shortener = build(:shortener, url: "www.toto.com")
        shortener.sanitize
        expect(shortener.new_url?).to eq(true)
      end
    end

    context "#sanitize" do

      it "changes 'www.google.com' to 'http://google.com'" do
        shortener = build(:shortener, url: 'www.google.com')
        shortener.sanitize
        expect(shortener.sanitized_url).to eq('http://google.com')
      end

      it "changes 'www.google.com/' to 'http://google.com'" do
        shortener = build(:shortener, url: 'www.google.com/')
        shortener.sanitize
        expect(shortener.sanitized_url).to eq('http://google.com')
      end

      it "changes 'google.com' to 'http://google.com'" do
        shortener = build(:shortener, url: 'google.com')
        shortener.sanitize
        expect(shortener.sanitized_url).to eq('http://google.com')
      end

      it "changes 'https://www.google.com' to 'http://google.com'" do
        shortener = build(:shortener, url: 'https://www.google.com')
        shortener.sanitize
        expect(shortener.sanitized_url).to eq('http://google.com')
      end

      it "changes 'http://www.google.com' to 'http://google.com'" do
        shortener = build(:shortener, url: 'http://www.google.com')
        shortener.sanitize
        expect(shortener.sanitized_url).to eq('http://google.com')
      end

      it "changes 'www.github.com/DatabaseCleaner/database_cleaner/' to 'http://github.com/DatabaseCleaner/database_cleaner'" do
        shortener = build(:shortener, url: 'www.github.com/DatabaseCleaner/database_cleaner/')
        shortener.sanitize
        expect(shortener.sanitized_url).to eq('http://github.com/databasecleaner/database_cleaner')
      end

      it "strips leading spaces from original_url" do
        shortener = build(:shortener, url: 'http://www.google.com')
        shortener.sanitize
        expect(shortener.url).to eq('http://www.google.com')
      end

      it "strips trailing spaces from original_url" do
        shortener = build(:shortener, url: 'http://www.google.com  ')
        shortener.sanitize
        expect(shortener.url).to eq('http://www.google.com')
      end

      it "dowcases original_url before saving it as sanitized_url" do
        shortener = build(:shortener, url: 'Google.com')
        shortener.sanitize
        expect(shortener.sanitized_url).to eq('http://google.com')
      end
    end

    describe "is valid with the follwing urls:" do

      it "http://www.google.com" do
        shortener = build(:shortener, url: "http://www.google.com")
        expect(shortener).to be_valid
      end

      it "http://www.google.com/" do
        shortener = build(:shortener, url: "http://www.google.com/")
        expect(shortener).to be_valid
      end

      it "https://www.google.com" do
        shortener = build(:shortener, url: "https://www.google.com")
        expect(shortener).to be_valid
      end

      it "https://google.com" do
        shortener = build(:shortener, url: "https://google.com")
        expect(shortener).to be_valid
      end

      it "www.google.com" do
        shortener = build(:shortener, url: "google.com")
        expect(shortener).to be_valid
      end

      it "google.com" do
        shortener = build(:shortener, url: "google.com")
        expect(shortener).to be_valid
      end

      it "https://www.google.com/maps/@37.7651476,-122.4243037,14.5z" do
        shortener = build(:shortener, url: "https://www.google.com/maps/@37.7651476,-122.4243037,14.5z")
        expect(shortener).to be_valid
      end

      it "https://www.google.com/search?newwindow=1&espv=2&biw=1484&bih=777&tbs=qdr%3Am&q=rspec+github&oq=rspec+g&gs_l=serp.1.2.0i20j0l9.10831.11965.0.13856.2.2.0.0.0.0.97.185.2.2.0....0...1c.1.64.serp..0.2.183.kqo6B3dAGtE" do
        shortener = build(:shortener, url: "https://www.google.com/search?newwindow=1&espv=2&biw=1484&bih=777&tbs=qdr%3Am&q=rspec+github&oq=rspec+g&gs_l=serp.1.2.0i20j0l9.10831.11965.0.13856.2.2.0.0.0.0.97.185.2.2.0....0...1c.1.64.serp..0.2.183.kqo6B3dAGtE")
        expect(shortener).to be_valid
      end

      it "my-google.com" do
        shortener = build(:shortener, url: "my-google.com")
        expect(shortener).to be_valid
      end

      it "https://en.wikipedia.org/wiki/HTML_element#Anchor" do
        shortener = build(:shortener, url: "https://en.wikipedia.org/wiki/HTML_element#Anchor")
        expect(shortener).to be_valid
      end

      it "https://mrajacse.files.wordpress.com/2012/08/how-to-solve-it-by-computer-r-g-dromey-for-unit-1.pdf" do
        shortener = build(:shortener, url: "https://mrajacse.files.wordpress.com/2012/08/how-to-solve-it-by-computer-r-g-dromey-for-unit-1.pdf")
        expect(shortener).to be_valid
      end

      it "https://github.com/nozbzh/urlshortener/issues/6" do
        shortener = build(:shortener, url: "https://github.com/nozbzh/urlshortener/issues/6")
        expect(shortener).to be_valid
      end

      it "https://www.youtube.com/watch?v=Q6otLsSRBqU" do
        shortener = build(:shortener, url: "https://www.youtube.com/watch?v=Q6otLsSRBqU")
        expect(shortener).to be_valid
      end

      it "https://warm-ravine-54181.herokuapp.com/" do
        shortener = build(:shortener, url: "https://warm-ravine-54181.herokuapp.com/")
        expect(shortener).to be_valid
      end
    end
  end
end
