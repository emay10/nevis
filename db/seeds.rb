# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
a = Agency.create(name: 'Agency')
u = User.create(email: 'knivets@gmail.com', password: 'qweqwe123', password_confirmation: 'qweqwe123', agency: a)
p = Policy.create(name: 'Policy 1', kind: :medical, carrier: 'Carrier 1', commission: 123)
Client.create(name: 'Client 1', status: :active, quantity: 1, number: '123123', policy: p, user: u)
