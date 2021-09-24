require 'net/http'
require 'json'
require "base64"
require 'nokogiri'

class GetGoodreadsData
  GOODREADS_URL = "https://www.goodreads.com"
  CURRENTLY_READING_URL = "#{GOODREADS_URL}/review/list_rss/25506258?key=dXKqua9sPLfNbjVfzsQHPBKJhicdgqAnJuaJ9obujkL4rD1Q&shelf=currently-reading"
  FINISHED_READING_URL = "#{GOODREADS_URL}/review/list_rss/25506258?key=dXKqua9sPLfNbjVfzsQHPBKJhicdgqAnJuaJ9obujkL4rD1Q&shelf=read&sort=date_read"
  FUTURE_READING_URL = "#{GOODREADS_URL}/review/list_rss/25506258?key=dXKqua9sPLfNbjVfzsQHPBKJhicdgqAnJuaJ9obujkL4rD1Q&shelf=to-read"
  BOOK_LIMIT = 4

  def get_data
    {
      "current": parse_rss_page(CURRENTLY_READING_URL),
      "finished": parse_rss_page(FINISHED_READING_URL),
      "future": parse_rss_page(FUTURE_READING_URL)
    }
  end

  private

  def parse_rss_page(url)
    response = api_response(url)
    parse_xml(response, url)
  end

  def parse_xml(body, url)
    xml_doc = Nokogiri::XML.parse(body)
    all_items = xml_doc.css("item").map do |item|

      description = item.css("description").text

      {
        title: item.css("title").text,
        author: pull_author_from_descr(description),
        image_url: pull_image_from_descr(description),
        link: pull_link_from_descr(description)
      }
    end

    if url.include?("to-read")
      all_items = all_items.shuffle
    end

    all_items.first(BOOK_LIMIT)
  end

  def pull_image_from_descr(description)
    Nokogiri::XML(description)
      .css('a img')[0]["src"]
      .sub("SY75", "SY475")
      .sub("SX50", "SY475")
  end

  def pull_author_from_descr(description)
    marker_1 = "author: "
    marker_2 = "<br/>"
    description[/#{marker_1}(.*?)#{marker_2}/m, 1]
  end

  def pull_link_from_descr(description)
    Nokogiri::XML(description)
      .css('a')[0]["href"]
  end

  def api_response(url)
    uri = URI(url)
    Net::HTTP.get(uri)
  end
end
