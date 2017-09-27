require 'nokogiri'
require 'open-uri'
require 'byebug'

hotel_url = "http://www.hostelsclub.com/hostel-en-24524.html"

l = (0 ... hotel_url.length).find_all { |i| hotel_url[i,1] == '-' }
hotel_id = hotel_url[l[1]+1..-6]

url = "http://www.hostelsclub.com/ajax/step15-hostel-comments.php?id="+hotel_id+"&lang=en"

hotel_page = Nokogiri::HTML(open(url))

reviews = hotel_page.css('p')[6]
a = reviews.text[reviews.text.index("{")..reviews.text.index("}")]
total_review = eval(a)[:all]

k = total_review%3
if k==0
	total_page = total_review/3
else
	total_page = total_review/3 + 1
end


(0..total_page-1).each do |i|
	url = "http://www.hostelsclub.com/ajax/step15-hostel-comments.php?id="+hotel_id+"&lang=en&start="+(i*3).to_s+"&all"
	puts url
	hotel_page = Nokogiri::HTML(open(url))
	(1..6).step(2) do |rev|
		review_text = hotel_page.css('p')[rev]
		if !review_text.nil?
			review_text = review_text.text
			puts review_text.strip.gsub("\\t","")
		end

		reviewer_info = hotel_page.css('p')[rev+1]
		if !reviewer_info.nil?
			reviewer_info = reviewer_info.text
			x = reviewer_info.index("from")
			y = reviewer_info.index("-")
			reviewer_info = reviewer_info[0..(reviewer_info.index("\\t")-1)]
			reviewer_name = reviewer_info[0..(x-2)]
			reviewer_place = reviewer_info[(x+5)..(y-2)]
			review_date = reviewer_info[(y+2)..-1]
			puts reviewer_name
			puts reviewer_place
			puts review_date
		end
		review_rate = hotel_page.css('tr td:nth-child(1)')[rev]
		puts review_rate.text[/\d+/].to_f/10
	end
end