require 'Geokit'
include Geokit::Geocoders


#Read Data from CSV

require 'csv'

arr = CSV.read('/Users/ashutosh/Documents/Seynse/LendingRetailers/Lending_Retailers_Detail.csv')
puts arr

location = "Risara Luxury, Amaral Vaddo, Taleigao, Goa"
coords = MultiGeocoder.geocode(location)
puts coords.lat
puts coords.lng