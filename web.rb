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
  
  validates_presence_of :first_name
  
end
class Flavor
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :cost, Float
  has n, :orderflavors
  
  validates_presence_of :name
  validates_presence_of :cost
  validates_numericality_of :cost

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
  
  validates_presence_of :name
  validates_presence_of :cost
  validates_numericality_of :cost
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
#_______________________________
get '/'do
erb :'index'
end
#___________________________________________
get '/orders/new' do
@order = Order.new
erb :'orders/new'
end
post '/orders' do
@order = Order.create(params[:order])
if @order.save
    redirect to("/orders/#{@order.id}")
  else
    erb :'orders/new'
  end
end
get '/orders/:id' do
if @order = Order.first( id: params[:id])
erb :'orders/show' , locals: { order: @order}

end
end
#__________________________________________
get '/admin/flavors/new' do
@flavor = Flavor.new
erb :'flavors/new'
end

post '/admin/flavors' do
@flavor = Flavor.create(params[:flavor])
if @flavor.save
    redirect to("/admin/flavors/#{@flavor.id}")
  else
    erb :'flavors/new'
  end
end
get '/flavors' do
@flavors=Flavor.all
erb :'/flavors/index'
end
get '/flavors/:id' do
if @flavor = Flavor.first( id: params[:id])
erb :'flavors/show' , locals: { flavor: @flavor}

end
end
delete '/admin/flavors/:id/delete' do
@flavor=Flavor.get(params[:id])
@flavor.destroy!
redirect to("/admin/flavors")
end
get '/admin/flavors' do
@flavors=Flavor.all
erb :'/flavors/a-index'
end
get '/admin/flavors/:id' do
if @flavor = Flavor.first( id: params[:id])
erb :'flavors/a-show' , locals: { flavor: @flavor}

end
end
#_______________________________
get '/admin/toppings/new' do
@topping = Topping.new
erb :'toppings/new'
end
post '/admin/toppings' do
@topping = Topping.create(params[:topping])
if @topping.save
    redirect to("/admin/toppings/#{@topping.id}")
  else
    erb :'toppings/new'
  end
end
get '/toppings' do
@toppings=Topping.all
erb :'/toppings/index'
end
get '/toppings/:id' do
if @topping = Topping.first( id: params[:id])
erb :'toppings/show' , locals: { topping: @topping}

end
end
delete '/admin/toppings/:id/delete' do
@topping=Topping.get(params[:id])
@topping.destroy!
redirect to("/admin/toppings")
end
get '/admin/toppings' do
@toppings=Topping.all
erb :'/toppings/a-index'
end
get '/admin/toppings/:id' do
if @topping = Topping.first( id: params[:id])
erb :'toppings/a-show' , locals: { topping: @topping}

end
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
