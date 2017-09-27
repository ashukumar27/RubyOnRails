require 'nokogiri'
require 'open-uri'
require 'byebug'

url = URI.encode("http://www.priceline.com/westwinds-inn-key-west-florida-FL-100587-hd.hotel-reviews-hotel-guides#reviews#tab_ratings")

page = Nokogiri::HTML(open(url))

total_reviews = page.css('div.paganation_left meta').attr('content').value.to_i

puts total_reviews

if total_reviews%10 == 0
	total_page = total_reviews/10
else
	total_page = total_reviews/10 +1
end

(1..total_page).each do |i|
	hotel_url = URI.encode("http://www.priceline.com/westwinds-inn-key-west-florida-FL-100587-hd.hotel-reviews-hotel-guides?pageNum="+i.to_s)
	puts hotel_url
	hotel_page = Nokogiri::HTML(open(hotel_url))
	hotel_page.css('div.guest_review').each do |rev|
		review_text_pos = rev.css('div.positive')
		if !review_text_pos.nil?
			review_text_pos = review_text_pos.text
			puts review_text_pos
		end
		review_text_neg = rev.css('div.negative')
		if !review_text_neg.nil?
			review_text_neg = review_text_neg.text
			puts review_text_neg
		end
		review_rate = rev.css('div.rating')
		if !review_rate.nil?
			review_rate = review_rate.text
			puts review_rate
		end
		review_info = rev.css('div.info br')[0]
		if !review_info.nil?
			review_date = review_info.next
			if !review_date.nil?
				review_date = review_date.text.strip
				puts review_date
			end
			reviewer_loc = review_info.previous
			if !reviewer_loc.nil?
				reviewer_loc = reviewer_loc.text.strip[5..-1]
				puts reviewer_loc
			end
		end
		puts "\n\n\n"

	end
end