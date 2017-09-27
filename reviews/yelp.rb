require 'nokogiri'
require 'open-uri'
require 'byebug'

# hotel_url = "https://www.yelp.com/biz/hey-cookie-san-francisco/"
# hotel_url = "https://www.yelp.com/biz/ichido-san-francisco-6"
url = "https://www.yelp.com/biz/tadu-ethiopian-kitchen-san-francisco-3?start="

hotel_page = Nokogiri::HTML(open(url,"User-Agent" => "yes"))
total_page = hotel_page.css('div.page-of-pages').text
total_page = total_page.gsub("\n",'').strip[10..-1].to_i
(1..total_page).each do |i|
	hotel_page.css('div.review--with-sidebar').each do |rev|
		review_text = rev.css('div.review-content p')
		if !review_text.nil?
			review_text = review_text.text
			puts review_text
		end
		review_rate = rev.css('div.rating-very-large img')
		if !review_rate.nil? and !review_rate.empty?
			review_rate = review_rate.attr('alt').value[0..2]
			puts review_rate
		end
		review_date = rev.css('span.rating-qualifier')
		if !review_date.nil?
			review_date = review_date.text
			puts review_date
		end
		reviewer_name = rev.css('a.user-display-name')
		if !reviewer_name.nil?
			reviewer_name = reviewer_name.text
			puts reviewer_name
		end
		reviewer_location = rev.css('li.user-location b')
		if !reviewer_location.nil?
			reviewer_location = reviewer_location.text
			puts reviewer_location
		end
		review_count = rev.css('li.review-count b')
		if !review_count.nil?
			review_count = review_count.text
			puts review_count
		end
		puts "\n\n\n"
	end
	hotel_url = url+(i*20).to_s
	hotel_page = Nokogiri::HTML(open(hotel_url,"User-Agent" => "yes"))
	puts hotel_url
end