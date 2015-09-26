Rails.logger.info "Seeding Cabs...."

Cab.delete_all
Cab.create(id:1, name: "Mini")
Cab.create(id: 2, name: "Sedan")
Cab.create(id:3, name: "Prime")