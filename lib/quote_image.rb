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
    sizes[:width]
  end

  def height
    sizes[:height]
  end

  def orientation
    case width / height
    when 0...0.8
      ORIENTATIONS[0]
    when 0.8...1.2
      ORIENTATIONS[1]
    else
      ORIENTATIONS[2]
    end
  end

  def sizes
    fast_image = FastImage.size(github_url)

    {
      width: fast_image[0].to_f,
      height: fast_image[1].to_f
    }
  end
end
