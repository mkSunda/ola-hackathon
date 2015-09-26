class Sudo

	def self.parse_command(params)
		
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
		
	end

	def self.parse_slack_command(text)
		
	end

end