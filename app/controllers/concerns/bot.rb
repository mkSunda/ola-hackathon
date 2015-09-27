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
        Cache.set("book mini", "cancel")
        #defunct in sandbox
        text = { text: "A mini is 2 minutes away. Should I book it for you ?" }
      else
        res = OlaCabs.new.sedan_available?(location)
        if res
          Cache.set("book sedan", "cancel")
          text = { text: "There are no minis available right now, would you like me to book a Sedan #{res} mins away at INR 13/km ?" }
        else
          #unreliable sedan availability; works for only 2,5,19,27,40
          { text: "Sorry! :sweat: All our cab operators our busy." }  
        end
      end
    when "find sedan"
      location = Location.find(2)
      res = OlaCabs.new.sedan_available?(location)
      if res
        Cache.set("book sedan", "cancel")
        text = { text: "A sedan is #{res} mins away. Would you like me to book it ?" }
      else
        Cache.invalidate
        { text: "Sorry! :sweat: All our cab operators are busy." }
      end
    when "book mini"
      #can't be achieved in sandbox
      user = User.first
      location = Location.find(2)
      ride = OlaCabs.new(user.token).book_mini(user, location)
      if ride
        msg = confirmation_message(ride)
        respond_back(msg)
        {}
      else
        { text: "Sorry! :sweat: All our cab operators our busy." }
      end
    when "book sedan"
      user = User.first
      location = Location.find(2)
      ride = OlaCabs.new(user.token).book_sedan(user, location)
      if ride
        msg = confirmation_message(ride)
        respond_back(msg)
        {}
      else
        { text: "Sorry! :sweat: All our cab operators are busy." }
      end
    when "book in"
      time = desired_time(action[:value], action[:unit])
      ScheduledBooking.new_booking(1,1,time)
      {text: "Ola! We have scheduled your cab for #{time.strftime("%I:%M %p")
}"}
    when "book at"
      time = "#{action[:value]} #{action[:unit]}"
      ScheduledBooking.new_booking(1,1,time.to_time)      
      {text: "Ola! We have scheduled your cab for #{time}"}
    when "driver location"
      ride = Ride.last
      msg = driver_location_message(ride)
    when "estimate"
      from = Location.where("lower(name) like ?","%#{action[:from].downcase.strip}%").first
      to = Location.where("lower(name) like ?","%#{action[:to].downcase.gsub("?","").strip}%").first
      return {text: "Please enter valid locations"} if from.nil? || to.nil?
      @response = OlaCabs.new.ride_estimate(from.lat, from.lng, to.lat, to.lng)
      {text: "The fare is #{@response["ride_estimate"].first["amount_min"]}-#{@response["ride_estimate"].first["amount_max"]} INR" }
    when "cancel ride"
      { text: "Bleh! :expressionless: Please take the cab and leave." }
    when "thanks"
      { text: "Your welcome!:blush: It was a pleasure helping you book an Ola." }
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
      action = Cache.get[0]
      Cache.invalidate
      { cmd: action }
    #rely on session data for no actions
    elsif text.match(PATTERNS[:no])
      action = Cache.get[1]
      Cache.invalidate
      { cmd: action }
    elsif text.match(PATTERNS[:mini])
      { cmd: "find mini" }
    elsif text.match(PATTERNS[:sedan])  
      { cmd: "find sedan" }
    elsif text.match(PATTERNS[:book_in])
      matches = text.match(PATTERNS[:book_in]).captures
      { cmd: "book in", value: matches[0].squish, unit: matches[1].squish }
    elsif text.match(PATTERNS[:book_at])
      matches = text.match(PATTERNS[:book_at]).captures
      { cmd: "book at", value: matches[0].squish, unit: matches[1].squish }
    elsif text.match(PATTERNS[:driver_location])
      { cmd: "driver location" }
    elsif text.match(PATTERNS[:estimate])
      matches = text.match(PATTERNS[:estimate]).captures
      { cmd: "estimate", from: matches[0], to: matches[1]}
    elsif text.match(PATTERNS[:cancel_ride])
      { cmd: "cancel ride" }
    elsif text.match(PATTERNS[:thanks])
      { cmd: "thanks" }
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
  end

  def self.confirmation_message(ride)
    eta = ((ride.arrival_time - DateTime.now)/60).to_i
    {
      attachments: [
        {
            fallback: "A cab has been booked",

            color: "#E18B3D",

            pretext: "Hola! Your cab will arive in #{eta} minutes. crn: #{ride.crn}",
            text: "#{ride.driver_name}\t\t\t#{ride.car_model}\n#{ride.driver_number}\t\t\t\t\t\t#{ride.cab_number}",
        }
      ]
    }
  end

  def self.driver_location_message(ride)
    payload = {
    "text" => "Your driver's location: <https://maps.googleapis.com/maps/api/staticmap?zoom=15&size=600x300&markers=color:red%7Clabel:C%7C#{ride.driver_lat},#{ride.driver_lng}&maptype=roadmap&sensor=false| >"
    }
  end
  
end