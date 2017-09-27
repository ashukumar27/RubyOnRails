require 'monkeylearn'
require 'JSON'


# Basic configuration
Monkeylearn.configure do |c|
  c.token = '8b30b757d19b0e473e09af2681563154d0fa57f5'
end

txt1 = "Very nice hotel with polite staff Decent food and beverages. Good room service Awesome internet connectivity Loved the stay Nice buffet for breakfast lunch n dinner . I will love to stay again whenever I will be in Mumbai And also near airport"
txt2 = "I was on my to switzerland when my flight got cancelled becuse of their mistake. Very bad hotel in all respect. Worst ambience, bad service and ok facilities. location and  hospitality sums up."
txt3 = "fucking assholes got a very dirty room, will never book again. Cockroaches everywhere"


c = Monkeylearn.classifiers.classify('cl_TKb7XmdG', [txt2], sandbox: true)
r = Monkeylearn.classifiers.classify('cl_rZ2P7hbs', [txt2], sandbox: true)

#puts r.result
c.result[0].each do |e|
	puts e[0]["label"]
	#puts v
	end

#puts r.result[0][0]["probability"]
#puts c.result[0][0]["label"]
# puts r.result[0][0]["probability"]