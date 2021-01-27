require 'sinatra'
require "sinatra/json"
require "sinatra/reloader"
require_relative "./get_goodreads_data.rb"

get '/books/' do
  headers \
    "Access-Control-Allow-Origin"   => "*"

  book_data = GetGoodreadsData.new()

  json book_data.get_data
end
