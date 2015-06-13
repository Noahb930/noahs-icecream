require 'sinatra'
require 'data_mapper'

set :public_folder, Proc.new { File.join(root, 'public') }
# ---------------------------------------------------------
# Database Stuff
# http://datamapper.org/docs/properties.html
#

if ENV['RACK_ENV'] == 'production'
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/app.db")
end 
class Order
  include DataMapper::Resource
  property :id, Serial
  property :first_name, String
  has n, :orderflavors
 has n, :flavors, through: :orderflavors
 has n, :ordertoppings
  has n, :toppings, through: :ordertoppings
  
end
class Flavor
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :cost, Float
  has n, :orderflavors


end
class Customer
  include DataMapper::Resource
  property :id, Serial
  property :first_name, String
  property :last_name, String
  
end
class Topping
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :cost, Float
  has n, :ordertoppings
end
class Orderflavor
include DataMapper::Resource
property :id, Serial
belongs_to	:flavor
belongs_to :order
end
class Ordertopping
include DataMapper::Resource
property :id, Serial
belongs_to	:topping
belongs_to :order
end
DataMapper.finalize
Order.auto_upgrade!
Flavor.auto_upgrade!
Customer.auto_upgrade!
Topping.auto_upgrade!
Orderflavor.auto_upgrade!
Ordertopping.auto_upgrade!
#___________________________________________
get '/orders/new' do
erb :'orders/new' , locals: {orders: @orders}
end
post '/orders' do
@order = Order.create(params[:order])
redirect to("/orders/#{@order.id}")
end
get '/orders/:id' do
if @order = Order.first( id: params[:id])
erb :'orders/show' , locals: { order: @order}

end
end
get '/orders/:id/edit' do
@orders = Order.all
erb :'orders/edit'
end
#__________________________________________
get '/flavors/new' do
erb :'flavors/new'
end
get '/flavors' do
erb :'/flavors/index'
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
delete '/flavors/:id/delete' do
@flavor=Flavor.get(params[:id])
@flavor.destroy!
redirect to("/flavors")
end

#_______________________________
get '/toppings/new' do
erb :'toppings/new'
end
post '/toppings' do
@topping = Topping.create(params[:topping])
redirect to("/toppings/#{@topping.id}")
end
get '/toppings/:id' do
if @topping = Topping.first( id: params[:id])
erb :'toppings/show' , locals: { topping: @topping}

end
end
delete '/toppings/:id/delete' do
@topping=Topping.get(params[:id])
@topping.destroy!
redirect to("/toppings")
end
#_____________________________________________________________
get '/orderflavors/new' do
  @orders = Order.all
  @flavors = Flavor.all
  erb :'orderflavors/new', locals: { orders: @orders, flavors: @flavors }

end
post '/orderflavors' do
@orderflavor = Orderflavor.create(params[:orderflavor])
redirect to("/orders/#{@orderflavor.order_id}")
end
delete '/orderflavors/:id/delete' do
@orderflavor=Orderflavor.get(params[:id])
@orderflavor.destroy!
redirect to("/orders/#{@orderflavor.order_id}")
end
#_____________________________________________________________
get '/ordertoppings/new' do
  @orders = Order.all
  @toppings = Topping.all
  erb :'ordertoppings/new', locals: { orders: @orders, toppings: @toppings }

end
post '/ordertoppings' do
@ordertopping = Ordertopping.create(params[:ordertopping])
redirect to("/orders/#{@ordertopping.order_id}")
end
delete '/ordertoppings/:id/delete' do
@ordertopping=Ordertopping.get(params[:id])
@ordertopping.destroy!
redirect to("/orders/#{@ordertopping.order_id}")
end
