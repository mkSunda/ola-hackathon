class OlaCabs

  def initialize(token = nil)
    @access_token = token
  end
	
	def book_ride(pickup_lat, pickup_lng, pickup_mode = "NOW", category = nil)
  	url = "http://sandbox-t.olacabs.com/v1/bookings/create?pickup_lat=#{pickup_lat}&pickup_lng=#{pickup_lng}&pickup_mode=#{pickup_mode}&category=sedan"
  	# url = "http://sandbox­-t.olacabs.com/v1/bookings/create?pickup_lat=12.950072&pickup_lng=77.642684&pickup_mode=NOW&category=sedan"
    res = RestClient.get(url, headers){ |i,j,k| i}
    JSON.parse(res)
  end

  def cancel_ride(crn)
    url = "http://devapi.olacabs.com/v1/booking/cancel?crn=82053435"
    res = RestClient.get url, headers
  end

  def ride_availability(pickup_lat, pickup_lng, category = nil)
    url = "http://sandbox-t.olacabs.com/v1/products?pickup_lat=#{pickup_lat}&pickup_lng=#{pickup_lng}"
    url += "&category=#{category}" if not category.blank?
  	res = RestClient.get url, headers
    JSON.parse(res)
  end

  # def ride_estimate(pickup_lat, pickup_lng, drop_lat, drop_lng, category = nil)
  # 	url = "https://devapi.olacabs.com/v1/products?pickup_lat=12.9491416&pickup_lng=77.64298&drop_lat=12.96&drop_lng=77.678&category=sedan"
  #   res = RestClient.get url, headers
  # end

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