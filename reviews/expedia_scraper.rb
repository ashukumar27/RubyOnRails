
#SampleURL: https://www.expedia.co.in/ugc/urs/api/hotelreviews/hotel/526338?_type=json&start=10&items=100
#Hotel URL: "https://www.expedia.co.in/Delhi-Hotels-Eros-Hotel-New-Delhi.h63545.Hotel-Information?chkin=05/09/2016&chkout=09/09/2016&rm1=a2&hwrqCacheKey=b4635590-73bc-4598-a225-084ce386ef3bHWRQ1471872773168&c=4b4afeb1-49bb-4743-b82c-7c6ff9580302&&exp_dp=5999.25&exp_ts=1471872773014&exp_curr=INR&exp_pg=HSR"
#Short URL : "https://www.expedia.co.in/Delhi-Hotels-Eros-Hotel-New-Delhi.h63545.Hotel-Information?chkin=05/09/2016&chkout=09/09/2016"
#hotel id : 63545
#things to do: 
#Store hotel URL
#Count the number of reviews from the front page, modify url to change items parameter
#Get Data in JSON 

require 'json'
require 'nokogiri'
require 'open-uri'

capitol = "https://www.expedia.co.in/Kuala-Lumpur-Hotels-Hotel-Capitol-Kuala-Lumpur.h201176.Hotel-Information?chkin=05/12/2016&chkout=09/12/2016"
russel =  "https://www.expedia.co.in/Sydney-Hotels-The-Russell-Hotel.h1086303.Hotel-Information?chkin=05/12/2016&chkout=09/12/2016"
hotel414="https://www.expedia.co.in/New-York-Hotels-414-Hotel.h661794.Hotel-Information?chkin=05/12/2016&chkout=09/12/2016"

## Step 1: Get Hotel URL from the Database
#hotel_page_json_url_raw="https://www.expedia.co.in/ugc/urs/api/hotelreviews/hotel/63545?_type=json&start=10&items=10"
#hotel_page_html_url="https://www.expedia.co.in/Delhi-Hotels-Eros-Hotel-New-Delhi.h63545.Hotel-Information?chkin=05/09/2016&chkout=09/09/2016"
hotel_page_html_url = russel

hotel_id_0 = hotel_page_html_url.split('.Hotel-Information')[0]
hotel_id_1 = hotel_id_0.split('.h')[1].to_i


##Step 2: Find the start and items parameter for full scraping
hotel_page_html= Nokogiri::HTML(open(hotel_page_html_url))
# #puts hotel_page_html
num_reviews= hotel_page_html.css('div.reviews-summary-box a.reviews-link span').text.to_i

hotel_page_json_url = "https://www.expedia.com/ugc/urs/api/hotelreviews/hotel/"+hotel_id_1.to_s+"?_type=json&start=10&items="+num_reviews.to_s


# # ## Step 3 {{Later}} Find the Start and items parameter for delta scraping


# ##Step 4: Scrape ::
hotel_page_json= Nokogiri::HTML(open(hotel_page_json_url))
data_hash = JSON.parse(hotel_page_json)

# #JSON.pretty_generate
# #puts JSON.pretty_generate data_hash["reviewDetails"]["reviewCollection"]["review"].first["hotelId"]
count = 1
data_hash["reviewDetails"]["reviewCollection"]["review"].each do |r|
	puts "*******************"
	puts "**     #{count}   **"
	puts r["title"]
	puts r["reviewText"]
	puts r["reviewSubmissionTime"]
	puts r["userLocation"]
	 puts (r["ratingOverall"].to_f)*2
	puts r["userNickname"]
	puts r["brandType"] #Source : Expedia or Hotels.com
	count+=1
	break if count==10
end
	
#review_title = data_hash["reviewDetails"]["reviewCollection"]["review"]["title"]
#puts review_title

