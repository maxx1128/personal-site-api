# frozen_string_literal: true

require 'fastimage'

class QuoteImage
  ORIENTATIONS = ['portrait', 'square', 'landscape']

  def initialize(base_url)
    @base_url = base_url
  end

  def github_url
    "https://raw.githubusercontent.com/maxx1128/anime-quote-collection/master/#{@base_url}".gsub(' ', '%20')
  end

  def width
    FastImage.size(github_url)[0]
  end

  def height
    FastImage.size(github_url)[1]
  end

  def orientation
    case width / height
    when 0...0.85
      ORIENTATIONS[0]
    when 0.8...1.15
      ORIENTATIONS[1]
    else
      ORIENTATIONS[2]
    end
  end
end
