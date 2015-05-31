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
  property :cost, Float
end
class Customer
  include DataMapper::Resource
  property :id, Serial
  property :fname, String
  property :lname, String
end
DataMapper.finalize
Flavor.auto_upgrade!
Customer.auto_upgrade!
get '/flavors/new' do
erb :'flavors/new'
end
post '/flavors' do
@flavor = Flavor.create(params[:flavor])
redirect to("/flavors/#{@flavor.id}")
end
get '/flavors/:id' do
if @flavor = Flavor.first( id: params[:id])
erb :'flavors/show' , locals: { flavor: @flavor}

end
end
#_______________________________
get '/customers/new' do
erb :'customers/new'
end
post '/customers' do
@customer = Customer.create(params[:customer])
redirect to("/customers/#{@customer.id}")
end
get '/customers/:id' do
if @customer = Customer.first( id: params[:id])
erb :'customers/show' , locals: { customer: @customer}

end
end

