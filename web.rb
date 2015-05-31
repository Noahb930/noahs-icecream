require 'sinatra'
require 'data_mapper'

# ---------------------------------------------------------
# Database Stuff
# http://datamapper.org/docs/properties.html
#

if ENV['RACK_ENV'] == 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end

class Flavor
  include DataMapper::Resource
  property :id, Serial
  property :name, String
end
DataMapper.finalize
Flavor.auto_upgrade!
get '/flavors/new' do
erb :'flavor/new'
end
post '/flavors' do
@flavor = Flavor.create(params[:flavor])
redirect to("/flavors/#{@flavor.id}")
end
get '/flavors/:id' do
if @flavor = Flavor.first( id: params[:id])
erb :'show/display' , locals: { flavor: @flavor}

end
end

