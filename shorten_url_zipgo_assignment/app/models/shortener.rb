class Shortener < ApplicationRecord
    require 'csv'

  validates :url, presence: true, on: :create
  validates_format_of :url,
    with: /\A(?:(?:http|https):\/\/)?([-a-zA-Z0-9.]{2,256}\.[a-z]{2,4})\b(?:\/[-a-zA-Z0-9@,!:%_\+.~#?&\/\/=]*)?\z/
  before_create :generate_shorten_url

  def generate_shorten_url
    chars = ['0'..'9','A'..'Z','a'..'z'].map{|range| range.to_a}.flatten
    self.shorten_url = 6.times.map{chars.sample}.join
    self.shorten_url = 6.times.map{chars.sample}.join until Shortener.find_by_shorten_url(self.shorten_url).nil?
  end

  

  def find_duplicate
    Shortener.find_by_sanitized_url(self.sanitized_url)
  end

  def new_url?
    find_duplicate.nil?
  end

  def sanitize
    self.url.strip!
    self.sanitized_url = self.url.downcase.gsub(/(https?:\/\/)|(www\.)/, "")
    self.sanitized_url.slice!(-1) if self.sanitized_url[-1] == "/"
    self.sanitized_url = "http://#{self.sanitized_url}"
  end
end
