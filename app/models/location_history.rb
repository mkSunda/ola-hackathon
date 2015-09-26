class LocationHistory < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  def self.track
    time = DateTime.now
    locations = Location.all
    locations.each do |loc|
      begin
        cab = OlaCabs.new
        response = cab.ride_availability(loc.lat, loc.lng, "sedan")
        Rails.logger.info(response)
        output = response["categories"][0]
        #non availability
        if output["eta"] == -1
          data = { location_id: loc.id, cab_id: 2, eta: -1, distance: -1, time: time }
        else
          data = { location_id: loc.id, cab_id:2, eta: output["eta"], distance: output["distance"], type: output["fare_breakup"][0]["type"], time: time }
          unless output["fare_breakup"][0]["surcharge"]
            data[:surcharge_type] = output["fare_breakup"][0]["surcharge"][0]["type"]
            data[:surcharge_value] = output["fare_breakup"][0]["surcharge"][0]["value"]
          end
        end
        LocationHistory.create(data)
        Rails.logger.info(data)
        sleep(2)
      rescue Exception => e
        Rails.logger.error("AAAAAA location: #{loc.id} #{e.message} ")
      end
    end
  end

end
