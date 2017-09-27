#Scraper For Hostelworld.com


require 'nokogiri'
require 'open-uri'


#Define Page URL
hotel_page_url = "http://www.hostelworld.com/hosteldetails.php/Smile-Society/Bangkok/49651/reviews"
hotel_page= Nokogiri::HTML(open(hotel_page_url))


#Get links of all review pages from Pagination URLs
review_url_array=[]
hotel_page.css('a.pagination-page-number').map { 
	|e| review_url_array<< e['href']  
}

#loop from  review_url_array.length-1 : the code above captures one blank element in the end

## Section 2 : Read all the individual reviews and store content in different variables - then push in a database

puts "URL Array Created #{review_url_array.length-1} Pages"

page1 = "http://www.hostelworld.com/hosteldetails.php/Smile-Society/Bangkok/49651/reviews#reviewFilters"

review = Nokogiri::HTML(open(page1))

	begin
		review_link = page1
		puts review_link 
	rescue
		puts "Review Link"
	end
	
	### Review Title not available	

	begin
		review_text= review.css('div.reviewtext')[0].text
		puts review_text 
	rescue
		puts "Review Text"
	end

	begin
		review_date= review.css('span.reviewdate')[0].text
		date_converted= Date.parse review_date
		puts review_date
	rescue
		puts "Review date"
	end

	begin
		customer_details = review.css('li.reviewerdetails')[0].text
		str = customer_details.split(",")
		customer_location =  str[0]
		customer_gender= str[1]
		customer_agegroup= str[2]
		puts customer_location
		puts customer_gender
		puts customer_agegroup
	rescue
		puts "Customer Location"
	end


	begin
		customer_rating = review.css('div.textrating')[0].text
		puts customer_rating
	rescue
		customer_rating = nil
	end

	begin
		customer_name = review.css('li.reviewername')[0].text
		puts customer_name
	rescue
		puts "Customer Name"
	end

	begin
		all_reviews_by_customer = review.css('li.reviewernumber')[0].text
		puts all_reviews_by_customer
	rescue
		puts "All reviews by customer"
	end

	begin
		reviewer_rank = review.css('li.reviewerrank')[0].text
		puts reviewer_rank
	rescue
		puts "Reviewer Rank"
	end

	# begin
	# 	reply_by_hotel = review.css('div.mgrRspnInline')[0].text
	# 	#puts reply_by_hotel
	# rescue
	# 	puts "Reply by Hotel"
	# end
