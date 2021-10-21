require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader'
require_relative './get_goodreads_data'
require_relative './get_quote_images'

get '/books/' do
  headers \
    'Access-Control-Allow-Origin'   => '*'

  json GetGoodreadsData.new.get_data
end

get '/quote/random/' do
  redirect GetQuoteImages.new.get_random_image
end
