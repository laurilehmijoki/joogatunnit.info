require 'rubygems'
require 'sinatra'

set :static, true
set :public, 'public'

get '/api/:school' do
  content_type :json  
  File.open("json/#{params[:school]}", 'rb').read
end

get '/' do
  File.read(File.join('public', 'index.html'))
end
