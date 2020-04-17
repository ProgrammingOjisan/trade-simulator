# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

    (1..30).each do |i|
        User.create(name: "Mr.NO"+i.to_s, email: "seeds"+i.to_s+"@test.com", password: "password"+i.to_s)
        i += 1
    end