class Sudo

	def self.parse_command(params)
		params[:time] = params[:command].match('([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9] [APap][.][mM][.]').to_a.first
		params[:time] = params[:command].match('([0-9]|0[0-9]|1[0-9]|2[0-3]) o\'clock').to_a.first if params[:time].nil?
		params[:category] = params[:command].match('mini|sedan|prime').to_a.first
		params[:command] = params[:command].match('book|cancel|call|track|get|availability').to_a.first
	end

	def self.respond_back(params)

		cab = OlaCabs.new(params[:access_token])
		command = parse_command(params)
		validate_command(command)

		return nil if command.blank?

		case command
		when "availability"
	    @response = cab.ride_availability(params[:lat], params[:lng], params[:category])
	  when "book", "call", "get"
	  	@response = cab.book_ride(params[:lat], params[:lng])

	  when "cancel"

	  when "estimate"

	  when "track"
	  	
	  end
  	
	end

	def self.validate_command(command)
		true
	end

	def self.parse_slack_command(text)
		params = {}

		if text.blank?
			params[:command] = "availability"
			params[:category] = "Sedan"
			params[:lat] = "12.9491416"
			params[:lng] = "77.6429"
		end
		params
	end

	def self.app_formatting(json, params)
		case params[:command]
		when "availability"
			output = {}
			return nil if json["categories"].blank?
 			json["categories"].each do |category|
				output[category["display_name"]] = {"eta" => category["eta"]}
			end
			return output
		when "book", "call", "get"
			return json
		end
		json
	end

	def self.slack_formatting(json)

		return {"text" => "There are no cabs available right now, will let you know when i find one."} if json["categories"].blank?

		display_name = json["categories"].first["display_name"]
		eta = json["categories"].first["eta"]
		cost_per_distance = json["categories"].first["fare_breakup"].first["cost_per_distance"]

		{
    "text" => "There is a #{display_name} #{eta} mins away at INR #{cost_per_distance}/km. Should I book it?"
		}
	end



end