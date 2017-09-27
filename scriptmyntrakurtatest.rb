require 'rubygems'
require 'nokogiri'
require 'open-uri'
#require 'JSON'
require 'csv'
require 'active_support/core_ext/hash'

require 'net/http'
require 'uri'
require 'json'


csv = CSV.open("testjackassmyfilemyntrakurta.csv", "w")


#In the base querry we can add more parameters as we want. This Querry returns a JSON object containing Useful data
BASE_QUERRY = "http://developer.myntra.com/v2/search/data/men-kurtas?userQuery=false&sort=new"

#This function extract the data from given url to csv file and returns true if success else if the url contains no more data it returns false
def extractDataFromURL(starturl, csv)

#To set SSL certificate
#system('set SSL_CERT_FILE=C:/RailsInstaller/cacert.pem')
	#page = Nokogiri::HTML(open(starturl, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/#537.36'))

	page2 = open(starturl, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/#537.36')
	contents = page2.read

	puts contents

	#dataString = page.css('p').inner_html.to_s
	#dataString = page.inner_html.to_s
	#dataString = page.to_s

        #jsonObj = Hash.from_xml(page.to_xml).to_json

	data = JSON.parse(contents)
	#grid_layout contains useful data as an Array
	puts data
	dataElem = data["data"]
	resultsElem = dataElem["results"]

	dataArray = resultsElem["products"]

	if(dataArray.empty?)
		return false
	end

	dataArray.each do |currentitem|
		starttimestamp = Time.now

		#We extract the url of product page and find all data from that page 
		producturl = currentitem["url"]

		#productpage = Nokogiri::HTML(open(producturl))
		#productString = productpage.css('p').inner_html.to_s
		#productdata = JSON.parse(productString)

		remoteurl = "http://developer.myntra.com/style/" + currentitem["styleid"].to_s + "?w=720"
		titleofproduct = currentitem["product"]


		bigimgpath = currentitem["search_image"]

 		puts currentitem["search_image"]

		imagedef = JSON.parse(currentitem["imageEntry_default"])["resolutionFormula"].to_s
		    images = "http://assets.myntassets.com/w_360,q_70" + imagedef[imagedef.index("w_($width)/") + "w_($width)/".length-1..imagedef.length]

		#if !currentitem["search_image"].index("assets/").nil?
		#    images = "http://assets.myntassets.com/w_360,q_70/v1" + bigimgpath[currentitem["search_image"].index("assets/")-1..currentitem["search_image"].length]
	        #elsif !currentitem["search_image"].index("image/style").nil?
		#    images = "http://assets.myntassets.com/w_360,q_70/v1" + bigimgpath[currentitem["search_image"].index("image/style")-1..currentitem["search_image"].length]   
	        #elsif !currentitem["search_image"].index("images/style").nil?
		#    images = currentitem["search_image"]              
              
		#end

		strikeprice = currentitem["price"]
		lowestprice = currentitem["discounted_price"]
		discount = currentitem["dre_discount_label"]
		productcode = currentitem["styleid"].to_s

		puts imagedef
		currbrand = currentitem["brands_filter_facet"]

		#productattributes = productdata["long_rich_desc"][0]["attributes"].to_a
		#attributeslength = productattributes.size

		attributes = Array.new
		itr = 0
		#while itr<attributeslength
			attributes << "size:#{currentitem["sizes"]}"
			itr += 1
			 attributes << "color:#{currentitem["global_attr_base_colour"]}"
			itr += 1
			attributes << "productcode:#{currentitem["styleid"].to_s}"


		#end

		endtimestamp = Time.now

		csv << [starttimestamp, remoteurl,  titleofproduct, images, attributes, strikeprice, lowestprice , currbrand, "kurta", "myntra", endtimestamp]
		csv << [nil]

		puts "starttimestamp : #{starttimestamp}"
		puts "remoteurl : #{remoteurl}"
		puts "titleofproduct : #{titleofproduct}"
		puts "images : #{images}"
		puts "attributes : #{attributes}"
		puts "strikeprice : #{strikeprice}"
		puts "lowestprice : #{lowestprice}"
		puts "currbrand : #{currbrand}"
		puts "category : tshirt"
		puts "store : paytm"
		puts "endtimestamp : #{endtimestamp}"
		puts '-------------------------------------------------------'
		puts
	end

	return true
end



csv << ["starttimestamp", "remoteurl",  "titleofproduct", "images", "attributes", "strikeprice", "lowestprice" , "currbrand", "category", "store", "endtimestamp"]

items_per_page = "48"
#brandHash.each do |brandName,brandId|
#	puts "Brand Name : #{brandName}"
	page_count=1
	while true
		currentQuerry = BASE_QUERRY+"&p=#{page_count}&rows=#{items_per_page}"

		puts "Extracting page count = #{page_count}"
		puts "Data Querry : #{currentQuerry}"

		extractStatus = extractDataFromURL(currentQuerry, csv)

		if(extractStatus == false)
			puts "This Page Contains No Data"
			break
		else
			puts "All Data Extracted From this page"
		end

#		puts "Sleeping 5 sec to reduce load on server"
		#sleep (rand())

		page_count += 1
	end
#end
