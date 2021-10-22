# frozen_string_literal: true

require 'fastimage'

class QuoteImage
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
    when 1.25...999
      'horizontal'
    when 0...0.75
      'vertical'
    else
      'square'
    end
  end
end
