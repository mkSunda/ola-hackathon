class Bot

  def self.response(text)
    action = parse_command(text)
    command = action[:cmd]
    case command
    when "book in"
      time = desired_time(action[:value], action[:unit])
      ScheduledBooking.new_booking(1,1,time.to_time)
      {text: "Ola! We have scheduled your cab for #{time}"}
    when "book at"
      time = "#{action[:value]} #{action[:unit]}"
      ScheduledBooking.new_booking(1,1,time.to_time)      
      {text: "Ola! We have scheduled your cab for #{time}"}
    end
  end

  #using incoming webhooks
  def self.respond_back(text)
  end

  def self.parse_command(text)
    if text.match(PATTERNS[:book_in])
      matches = text.match(PATTERNS[:book_in]).captures
      { cmd: "book in", value: matches[0].squish, unit: matches[1].squish }
    elsif text.match(PATTERNS[:book_at])
      matches = text.match(PATTERNS[:book_at])
      { cmd: "book at", value: matches[0].squish, unit: matches[1].squish }
    end
  end

  def self.slack_formatting(json)
  end

  def desired_time(value, units)
    time = Time.now.in_time_zone("Mumbai")
    if units.starts_with?("min")
      time += value.send(:minutes)
    elsif units.starts_with?("h")
      time += value.send(:hours)
    end
    time.strftime("%I:%M %p")
  end
  
end