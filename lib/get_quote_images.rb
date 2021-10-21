class GetQuoteImages
  def initialize
    @image_paths = Dir.glob("images/quotes/*.{png,jpeg}")
  end

  def get_random_image
    get_github_raw_image_url(random_image_path)
  end

  private

  def random_image_path
    @image_paths.sample
  end

  def get_github_raw_image_url(path)
    "https://raw.githubusercontent.com/maxx1128/personal-site-api/master/#{path}"
  end
end
