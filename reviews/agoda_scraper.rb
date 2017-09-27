require 'nokogiri'
require 'open-uri'

# hotel_url = "https://www.agoda.com/ibis-bengaluru-hosur-road-hotel/hotel/bangalore-in.html"
hotel_url = "https://www.agoda.com/amari-don-muang-airport-bangkok-hotel/hotel/bangkok-th.html"
doc = Nokogiri::HTML(open(hotel_url))
s = doc.css('img.main-photo-image').attr('src').value
a = (0 ... s.length).find_all { |i| s[i,1] == '/' }
hotel_id = s[a[4]+1..a[5]-1]

#find total reviews
total_reviews = doc.css('div.basedon strong').text[/\d+/].to_i
puts total_reviews

#total pages
if total_reviews >1000
	rev_per_page = 1000
	if total_reviews%1000==0
		total_page=total_reviews/1000
	else
		total_page = total_reviews/1000 + 1
	end
else
	rev_per_page = total_reviews
	total_page=1
end
puts total_page

#(1..total_page).each do |i|
(1..4).each do |i|
	review_url = "https://www.agoda.com/NewSite/en-us/Review/ReviewComments?hotelId="+hotel_id+"&providerId=332&demographicId=0&page="+i.to_s+"&pageSize="+rev_per_page.to_s+"&sorting=1&providerIds=332&isReviewPage=false&isCrawlablePage=true"
	review_page = Nokogiri::HTML(open(review_url))
	#review info
	review_page.css('div.sub-section').each do |j|
		review_title = j.css('div.title').text
		 
		review_text = j.css('span.comment-text').text
		if review_text.empty?

			review_text = j.css('div.comment-detail span').text
		end
		
		if review_title.ascii_only? and review_text.ascii_only?
			
			puts review_title.strip
			puts review_text
			review_date = j.css('span.review-date')
			puts Date.parse(review_date.text[9..-1]).strftime("%Y-%m-%d") 
			review_rate = j.css('span.review-score-individual-review').attr('data-review-rating')
			puts review_rate 
			reviewer_info = j.css('span.review-reviewer-name')
			reviewer_name = reviewer_info.css('strong').text
			puts reviewer_name 
			reviewer_country = reviewer_info.text.gsub(/[' '\n]/,'')
			reviewer_country.slice!(reviewer_name)
			puts reviewer_country[4..-1]
			
		end
	end
end
	