require 'rubygems'
require 'sinatra'

set :static, true
set :public_folder, 'public'

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/skeleton' do
  File.read(File.join('public/skeleton', 'index.html'))
end
