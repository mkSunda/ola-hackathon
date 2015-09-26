Rails.logger.info "Seeding Cabs...."

User.delete_all
User.create(id: 1, name: "Raison", email: "raisondsouza@gmail.com", phone: "9964141735", token: "d26199590659426a87bd070809a92038")
