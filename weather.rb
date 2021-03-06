require 'sinatra'
require 'yahoo_weatherman'

DEBUG_SERVICE = false

def determine_weather(location)
	client = Weatherman::Client.new
	weather = client.lookup_by_location(location).condition['text']
	return weather
end

def determine_location(location)
	client = Weatherman::Client.new
	location_info = client.lookup_by_location(location).location
	city = location_info['city'].capitalize
	state = location_info['region'].upcase
	country = location_info['country'].capitalize
	final_location = "#{city}, #{state}, #{country}"
	return final_location
end

def determine_temp(location)
	client = Weatherman::Client.new
	temp = client.lookup_by_location(location).condition['temp']
	return temp
end

get '/' do
	erb :home
end

post '/weather' do
	location = params[:post]["location"]
	redirect to('/weather/' + URI.escape( location ) )
end

def render_weather_for( location )
	@weather = determine_weather(location)
	@location = determine_location(location)
	@temp = determine_temp(location)
		
	if DEBUG_SERVICE
		puts "****************************************"
		puts "#{@weather}"
		puts "****************************************"
	end

	case @weather
	when 'Sunny'
		erb :sunny
	when 'Cloudy'
		erb :cloudy
	when 'Snowy'
		erb :snowy
	when 'Fair'
		erb :fair
	when 'Partly Cloudy'
		erb :partly_cloudy
	when 'Rain'
		erb :rainy
	else
		erb :default
	end
end

get '/weather/:location' do
	location = params[:location]
	render_weather_for( location )
end

