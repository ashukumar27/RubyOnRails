require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'csv'

csv = CSV.open("myfilepaytmkurta19thFeb.csv", "w")
#sortType = ["sort_popular"]
sortType = ["sort_new"]

#Brand Id of all the brands
#brandHash = {"86 Pearl"=>165213,"Adhaans"=>130321,"Again? Vintage"=>429564,"Aj Dezines"=>169310,"Allen Solly"=>1482,"ALX New York"=>2088,"American Swan"=>20404,"Anytime"=>298835,"Atorse"=>91604,"Ausy"=>433862,"Azo"=>433825,"Baaamboos"=>121440,"Baba Rancho"=>434715,"Bandit"=>124558,"BASICS"=>1713,"Being Human"=>98520,"BENDIESEL"=>19011,"Black Coffee"=>113700,"Blacksoul"=>97929,"Blue Saint"=>161381,"Blumerq"=>17408,"Breakbounce"=>161184,"British Terminal"=>133962,"Brooklyn Blues"=>193799,"Brooklyn Borough"=>395081,"Cairon"=>17727,"Camaroon"=>154241,"Canary London"=>33816,"Caricature"=>131477,"Chewingum"=>131479,"Ciroco"=>98991,"Classy Casuals"=>97538,"Club X"=>433907,"Cobb"=>122498,"Colorplus"=>17487,"costom paid"=>425329,"Countryside"=>425918,"CROCKS CLUB"=>48950,"D'INDIAN CLUB"=>308630,"Dave"=>89967,"Dazzio"=>2168,"Denimize"=>425368,"Dennison"=>96430,"Derby Jeans Community"=>433578,"Donear"=>96270,"Double f"=>113266,"E ATAVIOS"=>37451,"Edjoe"=>125095,"Ekmatra"=>395386,"ELLOWS"=>438443,"Ennoble"=>438858,"Exitplay"=>439228,"Fabrobe"=>439205,"FASH-A-HOLIC"=>161528,"Fashion Tree"=>188593,"Fedrigo"=>166931,"Feed Up"=>116531,"Fifty Two"=>189354,"Flying Machine"=>1968,"value"=>"Flying Machine","French Connection"=>3411,"FUNK"=>35069,"Ganar Club"=>437282,"GLABROUS"=>169345,"Globus"=>1950,"Good Karma"=>33731,"Goplay"=>319533,"Grasim"=>18564,"Greenfibre"=>141085,"GUSTROW"=>425922,"HAWK"=>2880,"HIGHLANDER"=>99393,"Hobert"=>433851,"HW"=>48670,"I Know"=>1726,"I-VOC"=>140873,"Identiti"=>122395,"INEGO"=>18387,"Invern By Monteil"=>437576,"Jack & Jones"=>93946,"JadeBlue"=>141086,"Jads"=>117387,"Jainez"=>47459,"Jeance"=>37286,"Jermyn Crest"=>392104,"Jogur"=>1959,"John Pride"=>117631,"Kingswood"=>186626,"Kivon"=>98383,"La Milano"=>131462,"La Miliardo"=>17482,"LA SEVEN"=>94090,"Lamode"=>181470,"Leaf"=>3131,"Lee Marc"=>152538,"Lisova"=>438407,"LMFAO"=>98076,"Locomotive"=>98413,"London Bee"=>21483,"London Fog"=>124050,"LYF SHIRTS"=>424974,"Marc N' Park"=>183656,"MARK ANDERSON"=>18395,"MARK TAYLOR"=>99394,"Mavango"=>2601,"Mayank Modi"=>134373,"Meraki"=>139906,"Mode Manor"=>141096,"Moksh"=>81661,"Monteil & Munero"=>1962,"Montise"=>189339,"Nation Polo Club"=>21207,"NAUHWAR"=>369631,"Nexq"=>140432,"NFC"=>207268,"Numero Uno"=>1465,"Orange Valley"=>94097,"Orson"=>433566,"Oxford Club"=>132750,"Oxolloxo"=>18445,"Parron Clothing Co."=>429533,"Parx"=>163808,"Pazel"=>2739,"People"=>1494,"Pepe Jeans"=>50155,"Peter England"=>1518,"Piazza Italya"=>435268,"Platinum League"=>91798,"Private Image"=>81584,"Q Design"=>163018,"R & C"=>124908,"R&C"=>33385,"Rafters"=>135385,"Rapphael"=>443324,"Raymond"=>18561,"Red Country"=>21094,"Red Tape"=>1451,"Relish"=>116388,"Richlook"=>1703,"ROCKING SWAMY"=>135153,"Rockstar Jeans"=>435864,"Romain"=>436361,"S9 MEN"=>192565,"Scotchtree"=>435177,"See Designs"=>18112,"Showoff"=>433016,"Silver Streak"=>46579,"Skatti"=>154344,"Skie Studio"=>124557,"SLUB"=>18406,"SOLEMIO"=>98214,"Spawn"=>433744,"Speak"=>11776,"Spykar"=>2442,"Sting"=>18522,"Studio Nexx"=>117633,"Style Redo"=>436125,"Stylish"=>3075,"SUSPENSE"=>2395,"Tailor Craft"=>433336,"The G Street"=>49847,"The Golf Club"=>184365,"The Indian Garage Co."=>18390,"The Vinson Clothing"=>161331,"THINC"=>129323,"Thisrupt"=>97594,"TIMBERLAKE"=>322716,"Tomar"=>320293,"Trend"=>132709,"TSX"=>2380,"Tuscans"=>141084,"Unique"=>2772,"Unique for men"=>140968,"United Colors Of Benetton"=>2503,"University of Oxford"=>93140,"UNIXX"=>149912,"Urban Touch"=>91110,"Urbantouch"=>136,"URGE"=>95953,"Vai"=>328842,"Van Heusen"=>1511,"Vintage"=>3393,"Vishal Mega Mart"=>298923,"Vivaldi"=>440613,"Volume Zero"=>97791,"Wajbee"=>140201,"Warewell"=>48998,"Warriors"=>125045,"Western Vivid"=>395927,"White House"=>98616,"X-Secret"=>297668,"Yepme"=>1715,"YOLO - You Only Live Once"=>160418,"YUP"=>239936,"Yuvi"=>18117,"Zavlin"=>43078,"Zeal Garments"=>43074,"Zido"=>161603,"Zobello"=>112811,"Zorro"=>113412,"Zovi"=>116}
#brandHash = {"Allen Solly"=>1482, "American Swan"=>20404, "Flying Machine"=>1968}

#In the base querry we can add more parameters as we want. This Querry returns a JSON object containing Useful data
BASE_QUERRY = "https://catalog.paytm.com/v1/g/men/clothes-all/ethnic-wear/kurtas?sort_new=1"

#This function extract the data from given url to csv file and returns true if success else if the url contains no more data it returns false
def extractDataFromURL(starturl, csv)

#To set SSL certificate
#system('set SSL_CERT_FILE=C:/RailsInstaller/cacert.pem')

	outputArr = Array.new
	
	begin
		file = open(starturl)
		doc = Nokogiri::HTML(file) do
		    # handle doc

		page = Nokogiri::HTML(open(starturl))
		dataString = page.css('p').inner_html.to_s

		begin
		#  res = JSON.parse(string)
		data = JSON.parse(dataString)

		rescue JSON::ParserError => e
		  # string was not valid
		  puts "LEAVING AS ERROR IN PARSING"
                  break
		end

		#grid_layout contains useful data as an Array
		total_items = data["totalCount"]

		dataArray = data["grid_layout"]
		

		if(dataArray.empty?)
			outputArr[0] = false
			outpurArr[1] = total_items
			return outputArr
		end

		dataArray.each do |currentitem|
			starttimestamp = Time.now

			#We extract the url of product page and find all data from that page 
			producturl = currentitem["url"]
		#To set SSL certificate
		#system('set SSL_CERT_FILE=C:/RailsInstaller/cacert.pem')
			productpage = Nokogiri::HTML(open(producturl))
			productString = productpage.css('p').inner_html.to_s
			begin
			  productdata = JSON.parse(productString)

			rescue JSON::ParserError => e
		  	# string was not valid
		  	 puts "LEAVING AS ERROR IN PARSING"
                  	 break
			end

			remoteurl = productdata["shareurl"]
			titleofproduct = productdata["productName"]
			#for app take data from currentitem, for web take data from productdata
			#images = productdata["image_url"]
			images = currentitem["image_url"]
			strikeprice = productdata["actual_price"]
			lowestprice = productdata["offer_price"]
			currbrand = productdata["brand"]
			product_id = productdata["product_id"]
			productattributes = productdata["long_rich_desc"][0]["attributes"].to_a
			attributeslength = productattributes.size

			attributes = Array.new
			itr = 0
			while itr<attributeslength
				attributes << "#{productattributes[itr][0]}:#{productattributes[itr][1]}"
				itr += 1
			end

			endtimestamp = Time.now

			csv << [starttimestamp, remoteurl,  titleofproduct, images, attributes, strikeprice, lowestprice , currbrand, "kurta", "paytm", product_id, endtimestamp]
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
			puts "product_id : #{product_id}"
			puts "endtimestamp : #{endtimestamp}"
			puts '-------------------------------------------------------'
			puts
		#sleep(rand(1..3))
		end

		outputArr[0] = true
		outputArr[1] = total_items
		#sleep(50)
		return outputArr
	end
	rescue OpenURI::HTTPError => e
	  if e.message == '404 Not Found'
	     outputArr[0] = true
	     outputArr[1] = total_items
	    return outputArr
	    # handle 404 error
	  else
	    raise e
	    outputArr[0] = true
	    outputArr[1] = total_items
	    return outputArr
	  end
	end

end

csv << ["starttimestamp", "remoteurl",  "titleofproduct", "images", "attributes", "strikeprice", "lowestprice" , "currbrand", "category", "store", "product_id","endtimestamp"]

items_per_page = "30"
page_count=1

DUMMY_THRESHOLD_NUMBER = 10
totalItemCount = 1

#while totalItemCount < DUMMY_THRESHOLD_NUMBER
#brandHash.each do |brandName,brandId|
#	puts "Brand Name : #{brandName}"
	#page_count=1	
	while true
		currentQuerry = BASE_QUERRY+"&page_count=#{page_count}&items_per_page=#{items_per_page}"
		#currentQuerry = BASE_QUERRY+"&page_count=#{page_count}&items_per_page=#{items_per_page}&brand=#{brandId}"

		puts "Extracting page count = #{page_count}"
		puts "Data Querry : #{currentQuerry}"

		extractStatus,totalCount = extractDataFromURL(currentQuerry, csv)
		if(extractStatus == false)
			puts "This Page Contains No Data"
			break
		else
			if(DUMMY_THRESHOLD_NUMBER != totalCount)
			    DUMMY_THRESHOLD_NUMBER = totalCount
			end

			puts "All Data Extracted From this page"
		
		end

#		puts "Sleeping 5 sec to reduce load on server"

		puts "Changing Page Count "
		page_count += 1

		totalItemCount += 1
	end

#end
