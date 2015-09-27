class User < ActiveRecord::Base
  has_many :scheduled_bookings
  has_many :rides

  def ride_details
  	ride = self.rides.order("created_at").last
		scheduled_booking = self.scheduled_bookings.order("created_at").last
		output = nil
		if !ride.nil? && !scheduled_booking.nil?
			if ride.created_at > scheduled_booking.created_at
				output = {:category => ride.cab_type, :pickup_time => ride.arrival_time.in_time_zone("Mumbai").strftime("%I:%M %p"),
			 :driver_name => ride.driver_name, :driver_number => ride.driver_number, :cab_number => ride.cab_number,
			 :car_model => ride.car_model, :confirmed => true}
			else
				output = {:category => "Sedan", :pickup_time => scheduled_booking.pickup_time.in_time_zone("Mumbai").strftime("%I:%M %p"), :confirmed => false}
			end
		elsif not ride.nil?
			output = {:category => ride.cab_type, :pickup_time => ride.arrival_time.in_time_zone("Mumbai").strftime("%I:%M %p"),
			 :driver_name => ride.driver_name, :driver_number => ride.driver_number, :cab_number => ride.cab_number,
			 :car_model => ride.car_model, :confirmed => true}
		elsif not scheduled_booking.nil?
			output = {:category => "Sedan", :pickup_time => scheduled_booking.pickup_time.in_time_zone("Mumbai").strftime("%I:%M %p"), :confirmed => false}
		end
		output
  end
end
