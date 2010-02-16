# Required Gems
require 'rubygems'
require 'sinatra'
# Database and ORM
requre 'sqlite3'
require 'db/datamapper'
# A VERY Basic Authorization Module
require 'lib/authorization'

# Set UTF-8 Charset
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end
# Icludes a VERY Authorization Module from the lib
helpers do
  include Sinatra::Authorization
end

# App GET and POST Handlers aka Controllers


get '/' do
  @title = "Welcome to the AdServer built on Sinatra"
  erb :welcome
end

get '/ad' do
  id = repository(:default).adapter.select(
  'SELECT id FROM ads ORDER BY random() LIMIT 1;'
  )
  @ad = Ad.get(id)
  erb :ad, :layout => false
end

get '/list' do
  require_admin
  @title = "List Ads"
  @ads = Ad.all(:order => [:created_at.desc])
  erb :list
end

get '/new' do
  require_admin
  @title = "Create A New Ad"
  erb :new
end

post '/create' do
  require_admin
  @ad = Ad.new(params[:ad])
  @ad.content_type = params[:image][:type]
  @ad.size = File.size(params[:image][:tempfile])
  if @ad.save
    path = File.join(Dir.pwd, "/public/ads", @ad.filename)
    File.open(path, "wb") do |f|
      f.write(params[:image][:tempfile].read)
    end
    redirect "/show/#{@ad.id}"
  else
    redirect('/list')
  end
end

get '/delete/:id' do
  require_admin
  ad = Ad.get(params[:id])
  unless ad.nil?
    path = File.join(Dir.pwd, "/public/ads", ad.filename)
    File.delete(path)
    ad.delete unless ad.nil?
  end 
  redirect('/list')
end

get '/show/:id' do
  require_admin
  @ad = Ad.get(params[:id])
  if @ad
    erb :show
  else
    redirect('/list')
  end
end

get '/click/:id' do
  ad = Ad.get(params[:id])
  ad.clicks.create(:ip_address => env["REMOTE_ADDR"])
  redirect(ad.url)
end