class Sudo

	def self.parse_command(params)
		params[:command]
	end

	def self.respond_back(params)

		cab = OlaCabs.new
		command = parse_command(params)
		validate_command(command)

		case command
		when "availability"
	    @response = cab.ride_availability(params[:lat], params[:lng], params[:category])
	  when "book"

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