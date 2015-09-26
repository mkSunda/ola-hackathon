class ApiController < ApplicationController
  def index
    @response = Sudo.respond_back(params)
    render :json => @response.as_json
  end

  def slack
    raise "You are not authorized"  if params[:token] != 'jDJikfKaPyuCUZfBCU72dcwo'
    @response = Sudo.respond_back(Sudo.parse_slack_command(params[:text]))
  end
end
