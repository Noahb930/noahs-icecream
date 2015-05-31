require 'sinatra'
require 'data_mapper'

# ---------------------------------------------------------
# Database Stuff
# http://datamapper.org/docs/properties.html
#

if ENV['RACK_ENV'] == 'development'
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
else
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
end
Class Flavor
include DataMapper::Resource
property :id, Serial
property :name, String
property :cost_in_cents, Integer
end
DataMapper.finalize
Flavor.auto_upgrade!
get '/flavors/new' do
erb:'flavor/new'
end
get '/' do
"<h1>WELCOME TO NOAH'S ICECREAM PARLOR!</h1>"
end

