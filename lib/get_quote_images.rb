require 'net/http'
require 'json'

class GetQuoteImages
  GITHUB_URL = 'https://api.github.com/repos/maxx1128/anime-quote-collection/git/trees/master?recursive=1'

  def get_random_image
    get_github_raw_image_url(random_image_path)
  end

  def get_github_raw_image_url(path)
    "https://raw.githubusercontent.com/maxx1128/anime-quote-collection/master/#{path}"
  end

  def random_image_path
    all_images_paths.sample
  end

  def all_images_paths
    github_api_data['tree']
      .select { |item| item['path'].include?('images/') }
      .map { |item| item['path'].gsub(' ', '%20') }
  end

  def github_api_data
    uri = URI(GITHUB_URL)
    JSON.parse(Net::HTTP.get(uri))
  end
end
