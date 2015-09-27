class ScheduledBooking < ActiveRecord::Base
  belongs_to :user
  belongs_to :location

  STATUS = {pending: "pending", confirmed: "confirmed"}

  def confirm_booking
    self.update_attributes(status: STATUS[:confirmed])
  end

  def self.new_booking(user_id, location_id, time)
    self.create(user_id: user_id, location_id: location_id, pickup_time: time, status: STATUS[:pending])
  end

  def self.get_pending
    self.where(status: STATUS[:pending]).all
  end

end
