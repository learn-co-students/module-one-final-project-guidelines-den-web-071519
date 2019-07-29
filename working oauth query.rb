require 'rest-client'
require 'pry'
require 'json'

 class GetData
    @@base_url = "https://api.spotify.com/v1"

    def post
        newUrl = @@base_url + '/artists/0TnOYISbd1XYRBk9myaseg'
       key = RestClient.get(newUrl, 'Authorization' => 'Bearer BQCEBBKa0zpiEltmXIRPSuG0GUMD5Aa9pCED89utQTdG8V1FcvWZKqJtlCpKtcEXWirnamCst6dv2pe-Xp45qxITopscjic6VdIb8G2f1rqQDQjmCO0F1KI2I1qoQOBxDu1ks3xKrQ3Sub485jU')
        puts key
    end

    
 end

 newObj = GetData.new
 binding.pry