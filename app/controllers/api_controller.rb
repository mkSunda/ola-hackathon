class ApiController < ApplicationController
  # skip_before_filter :verify_authenticity_token

  def index
    params[:command] = params[:command].downcase
    @response = Sudo.respond_back(params)
    render :json => @response.as_json
  end

  def book
    cab = OlaCabs.new(params[:access_token])
    @response = cab.book_ride(params[:lat], params[:lng])
    render :json => @response.as_json
  end


  def slack
    raise "You are not authorized"  if params[:token] != 'jDJikfKaPyuCUZfBCU72dcwo'
    @response = Sudo.respond_back(Sudo.parse_slack_command(params[:text]))
    @slack_response = Sudo.slack_formatting(@response)
    render :json => @slack_response.as_json, :status => 200
    # render :text => "Successfully Done!"
  end

  def bot
    raise "You are not authorized"  if params[:token] != 'QtkxFXX2Vk8yDrkrEMbMASuf'
    text = params[:text]
    @bot_response = Bot.respond_back(text)
    render :json => @bot_response.as_json, :status => 200
  end
end
