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