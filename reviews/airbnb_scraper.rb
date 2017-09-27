require 'open-uri'
require 'nokogiri'
require 'csv'

#URL to be scraped
url="https://www.airbnb.co.in/s/Bangalore--Karnataka--India"

#Parse the page with Nokogiri
page = Nokogiri::HTML(open(url))

#Print the Page Content Scraped
name = []

page.css('h3.h5.listing-name').each do |line|
	name << line.text.strip
end

permo=[]
page.css('span.h3.price-amount').each do |price|
	permo<< price.text
end


#Write Data to CSV file
CSV.open("airbnb_listings.csv","w") do |file|
	name.length.times do |i|
		file<< [name[i],permo[i]]
	end
end


