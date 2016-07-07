# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.delete_all
Admin.create(:displayName => "Liz Wendland", :netid => "liz", :duid => '0489988')
Admin.create(:displayName => "Mark McCahill", :netid => "mccahill", :duid => '0435319')

User.delete_all
User.create(:displayName => "Liz Wendland", :netid => "liz", :duid => '0489988')
User.create(:displayName => "Mark McCahill", :netid => "mccahill", :duid => '0435319')
