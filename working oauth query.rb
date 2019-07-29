require 'rest-client'
require 'pry'
require 'json'

 class GetData
    @@base_url = "https://api.spotify.com/v1"
    attr_accessor :access_token
    def initialize
        @access_token = nil
    end

    def post
        token = RestClient.post('https://accounts.spotify.com/api/token',
            {'grant_type': 'client_credentials'},
            {'Authorization': 'Basic YzhjZTljY2NiMDczNDg2YmE5OTJkNGUyOTM0NzBhNzA6N2ZmYTRlY2Q4Yjk1NDQ2OGJlMTI2ZGZiZDY1MGU1NWM='})

        @access_token = JSON.parse(token)['access_token']
    end
    
 end

 newObj = GetData.new
 binding.pry