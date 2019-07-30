require_relative '../config/environment'

 class GetData
    def self.access_token
        token = RestClient.post('https://accounts.spotify.com/api/token',
        {'grant_type': 'client_credentials'},
        {'Authorization': 'Basic YzhjZTljY2NiMDczNDg2YmE5OTJkNGUyOTM0NzBhNzA6N2ZmYTRlY2Q4Yjk1NDQ2OGJlMTI2ZGZiZDY1MGU1NWM='})

        JSON.parse(token)['access_token']
    end
 end

 GetData.access_token