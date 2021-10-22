# frozen_string_literal: true

require 'net/http'
require 'json'
require_relative './quote_image'

class GetQuoteImages
  GITHUB_URL = 'https://api.github.com/repos/maxx1128/anime-quote-collection/git/trees/master?recursive=1'

  def initialize(orientations)
    @orientations = orientations.to_s.split(',')
  end

  def random
    random_image = if valid_orientations
                     all_images.shuffle.find { |image| @orientations.include? image.orientation }
                   else
                     all_images.sample
                   end

    random_image.github_url
  end

  def all_images
    github_api_data['tree']
      .select { |item| item['path'].include?('images/') }
      .map { |item| QuoteImage.new(item['path']) }
  end

  def valid_orientations
    return false if @orientations.empty?

    (@orientations - QuoteImage::ORIENTATIONS).empty?
  end

  def github_api_data
    uri = URI(GITHUB_URL)
    JSON.parse(Net::HTTP.get(uri))
  end
end
