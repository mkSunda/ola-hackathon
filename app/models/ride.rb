class Ride < ActiveRecord::Base

  def self.create_new(user, location, ride_response)
    rr = ride_response
    pickup_time = Time.now + rr["eta"].to_i.send(:minutes)
    self.create(user_id: user.id, location_id: location.id, crn: rr["crn"], driver_name: rr["driver_name"], driver_number: rr["driver_number"], cab_type: rr["cab_type"], cab_number: rr["cab_number"], car_model: rr["car_model"], driver_lat: rr["driver_lat"], driver_lng: rr["driver_lng"], arrival_time: pickup_time )
  end
end
