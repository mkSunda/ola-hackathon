class Location < ActiveRecord::Base
  has_many :scheduled_bookings
end
