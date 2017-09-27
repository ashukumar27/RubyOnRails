## Code to scrape Tripadvisor review data, save it in a database and display it

require 'nokogiri'
require 'open-uri'
require 'monkeylearn'
require 'JSON'
Monkeylearn.configure do |c|
  c.token = '8b30b757d19b0e473e09af2681563154d0fa57f5'
end



#Define Page URL
#Pick this from Database, run a loop
#hotel_page_url = "https://www.tripadvisor.in/Hotel_Review-g297628-d2038751-Reviews-Ibis_Bengaluru_Techpark-Bengaluru_Bangalore_Karnataka.html"


hotel414="https://www.tripadvisor.in/Hotel_Review-g60763-d217630-Reviews-414_Hotel-New_York_City_New_York.html"
russel="https://www.tripadvisor.in/Hotel_Review-g255060-d258459-Reviews-The_Russell_Hotel-Sydney_New_South_Wales.html"
parc="https://www.tripadvisor.in/Hotel_Review-g294265-d2093622-Reviews-Parc_Sovereign_Hotel_Albert_St-Singapore.html"
capitol="https://www.tripadvisor.in/Hotel_Review-g298570-d305464-Reviews-Capitol_Hotel-Kuala_Lumpur_Wilayah_Persekutuan.html"
premier="https://www.tripadvisor.in/Hotel_Review-g186338-d6945304-Reviews-Premier_Inn_London_Holborn_Hotel-London_England.html"
hotel_page_url = premier


hotel_page= Nokogiri::HTML(open(hotel_page_url))


## Section 1: Get Hotel Data 
hotel_name = hotel_page.css('div.warLocName')[0].text
hotel_city = hotel_page.css('span.locality')[0].text
hotel_country = hotel_page.css('span.country-name')[0].text
hotel_rating = hotel_page.css('img.sprite-rating_rr_fill')[0]['content']

puts "Hotels Details Read"

### Section 2: Read the reviews link in all the pages URLs, add to array

#get Maximum PageNumber in Pagination for loop
pagenums=[]
hotel_page.css('a.pageNum[data-page-number]').each do |num|
	pagenums<<num.text.to_i
end

puts "Pagenums read"

#Run a loop to generate all review pages url
url_array = []
#for i in 0..(pagenums.max-1)
for i in 0..0
	if i==0
		url_array<< hotel_page_url
	else
		url_array<< hotel_page_url.split('Reviews')[0]+"Reviews-"+"or"+i.to_s+"0"+hotel_page_url.split('Reviews')[1]
	end
end
# Review Pages URLs generated

puts "URL Array Created #{url_array.length} long"

review_url_array=[]
url_array.each do |each_page_url|

	review_page_read = Nokogiri::HTML(open(each_page_url))
	review_page_read.css('div.innerBubble a').map { 
		|link| 
		if link['href'].include? "#CHECK_RATES_CONT"
	 		review_url_array << hotel_page_url.split('/Hotel_Review')[0]+link['href']
	 	end 
	 }
end

puts "Review URL Array created #{review_url_array.length} long"

## End : Read all the reviews links and store in an array


## Section 3 : Read all the individual reviews and store content in different variables - then push in a database

 
review_url_array.each do |review_url_link|
	#review_url_link = review_url_array[review_url_link]
	review= Nokogiri::HTML(open(review_url_link))

	begin
		review_link = review_url_link
		puts review_link 
	rescue
		puts "Review Link"
	end
		
	begin
		review_title = review.css('div.quote')[0].text
		#puts review_title
	rescue
		puts "Review Title"
	end

	begin
		review_text= review.css('div.entry p').first.text
		puts review_text 
	rescue
		puts "Review Text"
	end

	#Classifier categories with varnames
	#Cleanliness cat_clean
	#Comfort & Facilities cat_cnf
	#Food cat_food
	#Internet cat_internet
	#Location cat_location
	#Staff cat_staff
	#Value For Money cat_vfm

	# review_text = "Very bad food, i vomited at its sight and smell, the room was dirty and staff was not courteous at all. Never stay in this"
	#review_text = "Very good food, the room was clean and amazing and staff was really helpful and cheerfully good"


	# c = Monkeylearn.classifiers.classify('cl_TKb7XmdG', [review_text], sandbox: true) #For Categories
	# r = Monkeylearn.classifiers.classify('cl_rZ2P7hbs', [review_text], sandbox: true)

	# c.result[0].each do |e|
	# 	l= e[0]["label"]
	# 	p= e[0]["probability"]
	# 	case l
	# 	when "Cleanliness"
	# 		puts "Clean"
	# 		puts p
	# 	when "Comfort & Facilities"
	# 		puts "CnF"
	# 		puts p
	# 	when "Food"
	# 		puts "Food"
	# 		puts p
	# 	when "Internet"
	# 		puts "Int"
	# 		puts p
	# 	when "Location"
	# 		puts "Loc"
	# 		puts p
	# 	when "Staff"
	# 		puts "Staff"
	# 		puts p
	# 	when "Value For Money"
	# 		puts "Value"
	# 		puts p
	# 	else puts "none"
	# 	end
	# end

	# break 

	# puts " * * * * "
	# puts r.result[0][0]["label"]
	# puts r.result[0][0]["probability"]

	begin
		review_date= review.css('span.ratingDate')[0]['content']
		date_converted= Date.parse review_date
		puts date_converted.strftime("%B")
	rescue
		puts "Review date"
	end

	begin
		customer_location = review.css('div.location')[0].text
		puts customer_location
	rescue
		puts "Customer Location"
	end

	begin
		customer_image = review.css('div.avatar a img')[0]['src']
		#puts customer_image
	rescue
		puts "Customer Image"
	end

	begin
		customer_rating = review.css('img.sprite-rating_s_fill')[0]['alt']
	rescue
		customer_rating = nil
	end
	puts 2*(customer_rating.split(' ')[0].to_f)

	begin
		customer_name = review.css('span.scrname')[0].text
		puts customer_name
	rescue
		puts "Customer Name"
	end

	begin
		all_reviews_by_customer = review.css('div.reviewerBadge span.badgeText')[0].text
		puts all_reviews_by_customer
	rescue
		puts "All reviews by customer"
	end

	begin
		hotel_reviews_by_customer = review.css('div.contributionReviewBadge span.badgeText')[0].text
		puts hotel_reviews_by_customer
	rescue
		puts "Hotel Reviews by customer"
	end

	begin
		reply_by_hotel = review.css('div.mgrRspnInline')[0].text
		#puts reply_by_hotel
	rescue
		puts "Reply by Hotel"
	end

end





