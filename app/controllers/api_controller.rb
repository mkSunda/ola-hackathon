class ApiController < ApplicationController
  def index
  	params[:command]
    params[:lat]
    params[:lng]
    cab = OlaCabs.new
    @response = cab.ride_availability(params[:lat], params[:lng], params[:category])
    render :json => @response.as_json
  end
end
