class ApiController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    params[:command] = params[:command].downcase
    @response = Sudo.respond_back(params)
    render :json => Sudo.app_formatting(@response, params).as_json
  end

  def book
    cab = OlaCabs.new(params[:access_token])
    @response = cab.book_ride(params[:lat], params[:lng])
    render :json => Sudo.app_formatting(@response).as_json
  end

  def details
    user = User.find(2)
    render :json => user.ride_details.as_json
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
    if params[:user_id] == "USLACKBOT"
      render :json => {}, :status => 200
    else
      text = params[:text]
      @bot_response = Bot.response(text)
      render :json => @bot_response.as_json, :status => 200
    end
  end
end
