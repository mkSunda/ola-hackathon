
namespace :location_history do
  desc "track pricing data"
  task :track => :environment do |tasks, args|
    LocationHistory.track
  end

  desc "fulfill pending bookings"
  task :fulfill => :environment do |tasks, args|
    bookings = ScheduledBooking.get_pending
    bookings.each do |b|
      user = b.user
      loc = b.location
      cab = OlaCabs.new(user.token)
      ride_response = cab.book_ride(loc.lat, loc.lng)
      ride = Ride.create_new(user, loc, ride_response)
      b.confirm_booking
      msg = Bot.confirmation_message(ride)
      Bot.respond_back(msg)
    end
  end  
end