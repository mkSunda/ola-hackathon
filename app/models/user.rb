class User < ActiveRecord::Base
  has_many :scheduled_bookings
  has_many :rides

  def ride_details
  	ride = self.rides.order("arrival_time").last
		scheduled_booking = self.scheduled_bookings.order("pickup_time").last
		output = {}
		if not ride.nil?
			output = {:category => "Sedan", :pickup_time => ride.arrival_time.strftime("%I:%M %p"),
			 :driver_name => ride.driver_name, :driver_number => ride.driver_number, :cab_number => ride.cab_number,
			 :car_model => ride.car_model, :confirmed => true}
		elsif not scheduled_booking.nil?
			output = {:category => "Sedan", :pickup_time => ride.pickup_time.strftime("%I:%M %p"), :confirmed => false}
		end
		output
  end
end
