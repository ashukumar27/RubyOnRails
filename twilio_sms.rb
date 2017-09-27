require 'twilio-ruby' 
 
# put your own credentials here 
account_sid = 'AC95d47156900c7d43a10fca958c2fb791' 
auth_token = '8b47a81df8e277edffdf9a8b4bb57845' 
 
# set up a client to talk to the Twilio REST API 
@client = Twilio::REST::Client.new account_sid, auth_token 
 
@client.account.messages.create({
	:from => '+12563051179', 
	:to => '+919741329821', 
	:body => 'Hi testing code',  
}) 