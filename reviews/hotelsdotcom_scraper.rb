#Scraper for Hotels.com

require 'nokogiri'
require 'open-uri'


#Define Page URL
#review_page_url = "https://in.hotels.com/hotel/details.html?hotel-id=184581&display=reviews"

hotel414="https://in.hotels.com/hotel/details.html?hotel-id=202198&display=reviews"
russel="https://in.hotels.com/hotel/details.html?hotel-id=221431&display=reviews"
parc="https://in.hotels.com/hotel/details.html?hotel-id=464470&display=reviews"
capitol="https://in.hotels.com/hotel/details.html?hotel-id=186788&display=reviews"

review_page_url = capitol

review= Nokogiri::HTML(open(review_page_url))

	begin
		review_link = review_page_url
		puts review_link 
	rescue
		puts "Review Link"
	end
	
	#Find the number of reviews on the page


	review_title_array=[]
	begin
		review_title = review.css('div.review-summary').each { |e| 
		review_title_array<<e.text 
		}
	rescue
		review_title_array<<""
	end
	


	review_text_array=[]
	begin
		review_text= review.css('div.review-content blockquote').each { |e|
		review_text_array<<e.text
		}
	rescue
		review_text_array<<""
	end

	review_date_array=[]
	begin
		review_date= review.css('span.date').each{ |e|
			review_date=e.text
			review_date_array<<review_date
	  }
	rescue
		review_date_array<<nil
	end


#Block comment
	##Customer Location : Extract last 2 words of Name - Country Code
	cust_location_array=[]
	begin
		customer_location = review.css('span.locality').each { |e|
		customer_location=e.text
		cust_location_array<<customer_location
		}
		puts cust_location_array
	rescue
		puts "Customer Location"
	end

	stay_type_array=[]
	begin
		stay_type = review.css('div.travel-data').each	{ |e|
			stay_type_array<<e.text
	  }
	rescue
		stay_type_array<<""
	end

	customer_rating_array=[]
	begin
		customer_rating = review.css('span.rating').each{ |e| 
		customer_rating_array<<e.text
	 }
		
	rescue
		customer_rating_array<<nil
	end

	customer_name_array=[]
	begin
		customer_name = review.css('div.review-card-meta-reviewer').each{ |e|
		customer_name_array<<e.text
  	}
		
	rescue
		customer_name_array<<""
	end

	reply_by_hotel_array=[]
	begin
		reply_by_hotel = review.css('div.review-card-response-bubble').each { |e|  
			reply_by_hotel_array<<e.text
		}
	rescue
		reply_by_hotel_array<<""
	end


	#for i in 0..(review_title_array.length-1)
	for i in 0..10
		puts review_title_array[i]
		puts review_text_array[i]
		puts review_date_array[i]
		puts stay_type_array[i]
		puts (customer_rating_array[i].split('/')[0].to_f)*2
		puts customer_name_array[i]
		puts reply_by_hotel_array[i]
		
	end
	