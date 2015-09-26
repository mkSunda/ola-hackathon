class OlaCabs
	
	def book_ride(pickup_lat, pickup_lng, pickup_mode = "NOW", category)
  	url = "http://devapi.olacabs.com/v1/booking/create?pickup_lat=12.9490936&pickup_lng=77.6443056&pickup_mode=NOW&category=sedan"
  	res = RestClient.get url, headers
  end

  def cancel_ride(crn)
    url = "http://devapi.olacabs.com/v1/booking/cancel?crn=82053435"
    res = RestClient.get url, headers
  end

  def ride_availability(pickup_lat, pickup_lng)
  	url = "https://devapi.olacabs.com/v1/products?pickup_lat=#{pickup_lat}&pickup_lng=#{pickup_lng}" + "&category=mini"

  	res = RestClient.get url, headers
  	
  end

  def ride_estimate(pickup_lat, pickup_lng, drop_lat, drop_lng, category = nil)
  	url = "https://devapi.olacabs.com/v1/products?pickup_lat=12.9491416&pickup_lng=77.64298&drop_lat=12.96&drop_lng=77.678&category=sedan"
    res = RestClient.get url, headers
  end

  def track_ride
  	url = "http://devapi.olacabs.com/v1/bookings/track_ride"
    res = RestClient.get url, headers
  end

  def collect_data
    LATLNGS.each do |ll|
      data = ride_availability(ll.lat, ll.lng)
    end
  end

  private
	  def headers
	  	{:content_type => :json, :accept => :json, :Authorization => "X-APP-TOKEN #{get_token}"}
	  end

	  def get_token
	    # todo
	  end
end