# frozen_string_literal: true

require "nokogiri"
require "open-uri"

class GetGoodreadsData
  GOODREADS_URL = "https://www.goodreads.com"
  CURRENTLY_READING_URL = "#{GOODREADS_URL}/review/list/25506258-maxwell?order=a&shelf=currently-reading&sort=date_added"
  FINISHED_READING_URL = "#{GOODREADS_URL}/review/list/25506258-maxwell?shelf=read&sort=date_read"
  BOOK_ROW_SELECTOR = ".bookalike"
  BOOK_LIMIT = 4

  def initialize
    @currently_reading_page = get_page(CURRENTLY_READING_URL)
    @finished_reading_page = get_page(FINISHED_READING_URL)
  end

  def get_data
    {
      "current": @currently_reading_page.search(BOOK_ROW_SELECTOR).first(BOOK_LIMIT).map { |r| get_row_data(r) },
      "finished": @finished_reading_page.search(BOOK_ROW_SELECTOR).first(BOOK_LIMIT).map { |r| get_row_data(r) }
    }
  end

  private

  def get_row_data(row)
    page_url = "#{GOODREADS_URL}#{row.at(".title a").attr("href")}"

    {
      title: get_title_from(row),
      author: get_author_from(row),
      image_url: get_cover_url_from(page_url),
      link: page_url
    }
  end

  def get_title_from(row)
    row.at(".title a").attr("title")
  end

  def get_author_from(row)
    row.at(".author a").text.split(", ").reverse.join(" ")
  end

  def get_cover_url_from(page_url)
    page = get_page(page_url)
    page.at("#coverImage").attr("src")
  end

  def get_page(url)
    Nokogiri::XML(open(url));
  end
end
