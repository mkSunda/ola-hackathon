class User < ActiveRecord::Base
  has_many :scheduled_bookings
  has_many :rides
end
