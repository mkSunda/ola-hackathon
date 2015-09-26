class ScheduledBooking < ActiveRecord::Base
  STATUS = {pending: "pending", confirmed: "confirmed"}
end
