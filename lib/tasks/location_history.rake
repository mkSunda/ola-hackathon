
namespace :location_history do
  desc "track pricing data"
  task :track => :environment do |tasks, args|
    LocationHistory.track
  end
end