class Sudo

	def self.parse_command(text)
		text
	end

	def self.respond_back(params)

		cab = OlaCabs.new
		command = parse_command(params[:command])
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
		if text.include? "availability"
			params[:command] = "availability"
			params[:lat] = "12.9491416"
			params[:lng] = "77.6429"
		end
		params
	end

end