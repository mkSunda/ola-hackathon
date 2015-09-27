class OlaCabs

  def initialize(token = nil)
    @access_token = token
  end
	
	def book_ride(pickup_lat, pickup_lng, pickup_mode = "NOW", category = 'sedan')
  	url = "http://sandbox-t.olacabs.com/v1/bookings/create?pickup_lat=#{pickup_lat}&pickup_lng=#{pickup_lng}&pickup_mode=#{pickup_mode}&category=#{category}"
  	# url = "http://sandbox­-t.olacabs.com/v1/bookings/create?pickup_lat=12.950072&pickup_lng=77.642684&pickup_mode=NOW&category=sedan"
    res = RestClient.get(url, headers){ |i,j,k| i}
    JSON.parse(res)
  end

  #used by slackbot
  #sandbox is always false
  def mini_available?(location)
    res = ride_availability(location.lat, location.lng, "mini")
    output = res["categories"][0]
    if output["eta"] == -1
      return false
    else
      return true 
    end
  end

  #used by slackbot
  #unreliable in sandbox
  def sedan_available?(location)
    res = ride_availability(location.lat, location.lng, "sedan")
    output = res["categories"][0]
    if output["eta"] == -1
      return false
    else
      return output["eta"]
    end
  end

  def book_mini(user, location)
    response = book_ride(location.lat, location.lng, "NOW", "mini")
    if response["status"] == "FAILURE"
      return false
    else
      ride = Ride.create_new(user, location, response)
    end    
  end

  def book_sedan(user, location)
    response = book_ride(location.lat, location.lng, "NOW", "sedan")
    if response["status"] == "FAILURE"
      return false
    else
      ride = Ride.create_new(user, location, response)
    end
  end

  def cancel_ride(crn)
    url = "http://devapi.olacabs.com/v1/booking/cancel?crn=82053435"
    res = RestClient.get url, headers
  end

  def ride_availability(pickup_lat, pickup_lng, category = nil)
    # pickup_lat = "12.950072" if pickup_lat.nil?
    # pickup_lng = "77.642684" if pickup_lng.nil?
    url = "http://sandbox-t.olacabs.com/v1/products?pickup_lat=#{pickup_lat}&pickup_lng=#{pickup_lng}"
    url += "&category=#{category}" if not category.blank?
  	res = RestClient.get url, headers
    JSON.parse(res)
  end

  def ride_estimate(pickup_lat, pickup_lng, drop_lat, drop_lng, category = "sedan")
  	url = "http://sandbox-t.olacabs.com/v1/products?pickup_lat=#{pickup_lat}&pickup_lng=#{pickup_lng}&drop_lat=#{drop_lat}&drop_lng=#{drop_lng}&category=#{category}"
    res = RestClient.get url, headers
    JSON.parse(res)
  end

  def track_ride
  	url = "http://devapi.olacabs.com/v1/bookings/track_ride"
    res = RestClient.get url, headers
  end

  def collect_data
    LATLNGS.each do |ll|
      data = ride_availability(ll.lat, ll.lng)
      # parse and store data
    end
  end

  private
	  def headers
      if @access_token.blank?
	  	  {:content_type => :json, :accept => :json, "X-APP-TOKEN" => "071533ba0db64fd0b8886d668b02abf7"}
      else
        {:content_type => :json, :accept => :json, "X-APP-TOKEN" => "071533ba0db64fd0b8886d668b02abf7", :Authorization => "Bearer #{@access_token}"} 
      end
	  end
end