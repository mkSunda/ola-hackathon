Rails.logger.info "Seeding Cabs...."

User.delete_all
User.create(id: 1, name: "Raison", email: "raisondsouza@gmail.com", phone: "9964141735", token: "d26199590659426a87bd070809a92038")
User.create(id: 2, name: "Himanshu", email: "himanshu@gmail.com", phone: "9611909523", token: "1e44ab4dedbc431aa969f930b8e5101f")
