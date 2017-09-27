

#Scraper For Booking.com


require 'nokogiri'
require 'open-uri'



#hotel_page_url = "http://www.booking.com/reviews/us/hotel/island-breeze-inn.html"

#Different hotels - for testing
russel="http://www.booking.com/reviews/au/hotel/russell.en-gb.html"
hotel414="http://www.booking.com/reviews/us/hotel/414.en-gb.html"
capitol="http://www.booking.com/reviews/my/hotel/capitol-kuala-lumpur.en-gb.html"
premier="http://www.booking.com/reviews/gb/hotel/premiertravelinnlondonkensington.en-gb.html"
parc="http://www.booking.com/reviews/sg/hotel/parc-sovereign-tyrwhitt.en-gb.html"

hotel_page_url=parc

#Not needed actually, needed for the case when full URL is posted
hotel_url = hotel_page_url.split('?')[0]

page1= hotel_url
id=1
review_pages=[]
begin	
	read_page1 = Nokogiri::HTML(open(page1+"?page="+id.to_s))
	next_page_link = read_page1.css('p.review_next_page')[0].text
	review_pages<<page1+"?page="+id.to_s
	id+=1
end while next_page_link.include? "Next page"

review_pages.each do |review_page|

	review = Nokogiri::HTML(open(review_page))

	#Read number of maximum reviews in a page
	range = review.css('p.page_showing')[0].text
	min= range.gsub('Showing','').split('-')[0]
	max= range.gsub('Showing','').split('-')[1]
	num_reviews= max.strip.to_i - min.strip.to_i+1
	
	count = 0
	begin

		
		
		begin
			review_pos= review.css('p.review_pos span')[count].text.strip
			#puts review_pos
		rescue
			puts "Positive review"
		end

		begin
			review_neg= review.css('p.review_neg span')[count].text.strip
			#puts review_neg
		rescue
			puts "Negative review"
		end

		review_text = review_pos+" " + review_neg
		puts review_text
		begin
			review_link = review.css('a.review_item_header_content')[count]['href']
			puts "http://www.booking.com"+review_link 
		rescue
			puts "Review Link"
		end
			
		begin
			review_title = review.css('a.review_item_header_content')[count].text
			puts review_title.strip
		rescue
			puts "Review Title"
		end

		begin
			review_date= review.css('p.review_item_date')[count].text
			date_converted= Date.parse review_date
			puts date_converted
		rescue
			puts "Review date"
		end

		begin
			customer_location = review.css('span.reviewer_country')[count].text
			puts customer_location.strip
		rescue
			puts "Customer Location"
		end

		begin
			tags = review.css('ul.review_item_info_tags')[count].text
			puts tags.strip
		rescue
			puts "Tags"
		end

		begin
			customer_rating = review.css('div.review_item_review_score')[count].text
			puts customer_rating.strip.to_f
		rescue
			customer_rating = nil
		end

		begin
			customer_name = review.css('div.review_item_reviewer span')[count].text
			puts customer_name.strip
		rescue
			puts "Customer Name"
		end

		begin
			all_reviews_by_customer = review.css('div.review_item_user_review_count')[count].text
			puts all_reviews_by_customer.strip
		rescue
			puts "All reviews by customer"
		end



		begin
			reply_by_hotel = review.css('div.mgrRspnInline')[0].text
			#puts reply_by_hotel
		rescue
			puts "Reply by Hotel"
		end

		count+=1
	end while count<3 #Should be based on  number of reviews
	
end