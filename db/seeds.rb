# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
races = Race.create([{ name: "orcs", buff_type: "defense", buff_quantity: 990 }, { name: "humans", buff_type: "power", buff_quantity: 900 }])
Hero.create(name: "Aragorn II", power: 1000, defense: 500, race_id: 2)
Hero.create(name: "Lurtz", power: 900, defense: 350, race_id: 1)
