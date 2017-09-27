require 'nokogiri'
require 'open-uri'
require 'byebug'


hotel_url = "http://www.holidayiq.com/Leela-Kempinski-Mumbai-hotel-3322.html"
doc=Nokogiri::HTML(open(hotel_url))
total_reviews = doc.css('div.detail-review-f1 h2').text[/\d+/].to_i
# total_reviews = page.xpath('//input[id="textReviewToBeDisplay"]/value').text
hotel_link = hotel_url[0..-6]
k=total_reviews%10
if k==0
	total_page = total_reviews/10
else
	total_page = total_reviews/10 + 1
end
	
#(1..total_page).each do |j|
(1..4).each do |j|
	url = hotel_link+"-p"+j.to_s+".html"
	page = Nokogiri::HTML(open(url))
	text_review = page.css('div.detail-review-by-hotel')
	if j == total_page
		review_per_page = k
	else
		review_per_page = 9
	end
	(0..review_per_page).each do |i|

		review_url = text_review.css('a.featured-blog-clicked')[i]
		
		if !review_url.nil? and !review_url.include?("Video")
			review_page = Nokogiri::HTML(open(review_url.attr('href')))
			#particular review block
			review_div = review_page.css('div.review-container')[0]
			#review details
			review_title = review_div.css('span.reviews-tag-line-link')
			if !review_title.nil?
				review_title = review_title.text.strip.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
				puts review_title
			end
			mem_name = review_div.css('li.reviewer-name span')
			if !mem_name.nil?
				mem_name = mem_name.text
				puts mem_name
			end
			review_text = review_div.css('div.review-block span')
			if !review_text.nil?
				review_text = review_text.text.strip.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
				puts review_text
			end
			review_rating = review_div.css('ul.personal-details li:nth-child(1) div:nth-child(2)')
			if !review_rating.nil?
				review_rate = review_rating.text
				puts review_rate
			end
			review_date = review_div.css('ul.personal-details li:nth-child(2) meta')
			if !review_date.empty?
				review_date = Date.parse(review_date.attr('content')).strftime("%Y-%m-%d")
				# review_date = review_date
				puts review_date
			end
			reviewer_reviews = review_div.css('li.reviewer-reviews span')
			if !reviewer_reviews.nil?
				reviewer_reviews = reviewer_reviews.text[/\d+/].to_i
				puts reviewer_reviews
			end

			cust_city =review_div.css('li.lives-city')
			if !cust_city.nil? 
				cust_city = cust_city.text[9..-1]
				puts cust_city
			end
			
		end
	end
end

