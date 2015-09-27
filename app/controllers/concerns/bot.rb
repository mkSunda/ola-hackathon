class Bot

  def self.response(text)
    action = parse_command(text)
    command = action[:cmd]
    case command
    when "cancel"
      { text: ":expressionless: Why are you wasting my time ? :rage:"}
    when "find mini"
      location = Location.find(2)
      res = OlaCabs.new.mini_available?(location)
      if res
        session[:action] = {yes: "book mini", no: "cancel" }
        #defunct in sandbox
        text = { text: "A mini is 2 minutes away. Should I book it for you ?" }
      else
        session[:action] = { yes: "book sedan", no: "cancel" }
        res = OlaCabs.new.sedan_available?(location)
        #unreliable sedan availability; works for only 2,5,19,27,40
        text = { text: "There are no minis available right now, would you like me to book a Sedan 17 mins away at INR 13/km ?" }
      end
    when "find sedan"
      location = Location.find(2)
      res = OlaCabs.new.sedan_available?(location)
      if res
        session[:action] = { yes: "book sedan", no: "cancel" }
        text = { text: "A sedan is #{res} mins away. Would you like me to book it ?" }
      else
        session.clear
        { text: "Sorry! :sweat: All our cab operators our busy." }
      end
    when "book mini"
      #can't be achieved in sandbox
    when "book sedan"
      user = User.first
      location = Location.find(2)
      ride = OlaCabs.new(user.token).book_sedan(user, location)
      if ride
        msg = confirmation_message(ride)
        respond_back(msg)
        {}
      else
        { text: "Sorry! :sweat: All our cab operators our busy." }
      end
    when "book in"
      time = desired_time(action[:value], action[:unit])
      ScheduledBooking.new_booking(1,1,time.to_time)
      {text: "Ola! We have scheduled your cab for #{time}"}
    when "book at"
      time = "#{action[:value]} #{action[:unit]}"
      ScheduledBooking.new_booking(1,1,time.to_time)      
      {text: "Ola! We have scheduled your cab for #{time}"}
    when "driver location"
      ride = Ride.last
      msg = driver_location_message(ride)
    when "estimate"
      from = Location.where("name is like '%?%'",action[:from]).first
      to = Location.where("name is like '%?%'",action[:to]).first
      {text: "Please enter valid locations"} if from.nil? || to.nil?
      @response = OlaCabs.new.ride_estimate(from.lat, from.lng, to.lat, to.lng)
      {text:"fare estimate is between #{@response["ride_estimate"]["amount_min"]} to #{@response["ride_estimate"]["amount_min"]}" }
    else
      {}
    end
  end

  #using incoming webhooks
  def self.respond_back(params)
    url = "https://hooks.slack.com/services/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"
    RestClient.post(url, params.to_json)
  end

  def self.parse_command(text)
    #rely on session data for yes actions
    if text.match(PATTERNS[:yes])
      action = session[:action][:yes]
      session.clear
      { cmd: action }
    #rely on session data for no actions
    elsif text.match(PATTERNS[:no])
      action = session[:action][:no]
      session.clear
      { cmd: action }
    elsif text.match(PATTERNS[:mini])
      { cmd: "find mini" }
    elsif text.match(PATTERNS[:sedan])  
      { cmd: "find sedan" }
    elsif text.match(PATTERNS[:book_in])
      matches = text.match(PATTERNS[:book_in]).captures
      { cmd: "book in", value: matches[0].squish, unit: matches[1].squish }
    elsif text.match(PATTERNS[:book_at])
      matches = text.match(PATTERNS[:book_at])
      { cmd: "book at", value: matches[0].squish, unit: matches[1].squish }
    elsif text.match(PATTERNS[:driver_location])
      { cmd: "driver location" }
    elsif text.match(PATTERNS[:estimate])
      matches = text.match(PATTERNS[:estimate]).captures
      { cmd: "estimate" from: matches[0], to: matches[1]}
    else
      {}
    end
  end


  def self.desired_time(value, units)
    time = Time.now.in_time_zone("Mumbai")
    if units.starts_with?("min")
      time += value.to_i.send(:minutes)
    elsif units.starts_with?("h")
      time += value.to_i.send(:hours)
    end
    time.strftime("%I:%M %p")
  end

  def self.confirmation_message(ride)
    {
      attachments: [
        {
            fallback: "A cab has been booked",

            color: "#E18B3D",

            pretext: "Hola! Your cab details: #{ride.crn}",
            text: "#{ride.driver_name}\t\t\t\t\t#{ride.car_model}\n#{ride.driver_number}\t\t#{ride.cab_number}",
        }
      ]
    }
  end

  def self.driver_location_message(ride)
    payload = {
    "text" => "Your driver's location: <https://maps.googleapis.com/maps/api/staticmap?zoom=15&size=600x300&markers=color:red%7Clabel:C%7C#{ride.driver_lat},#{ride.driver_lng}&maptype=roadmap&sensor=false| >",
    "icon_emoji" => ":earth_americas:"
    }
  end
  
end