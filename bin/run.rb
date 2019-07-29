require_relative '../config/environment'



base_url = 'https://api.spotify.com/v1/'
#key = gets.chomp
newUrl = base_url + 'search'
puts "Hey, put a song"
song = gets.chomp.gsub(' ', '%20')
puts "Hey, put a type (track/artist/album)"
type = gets.chomp.gsub(' ', ', ')
checker = RestClient.get("https://api.spotify.com/v1/search?q=#{song}&type=#{type}&limit=5", 'Authorization' => 'Bearer BQCzuzYBWZeRHRHFS1Kp5HCovToKxsR03lQZ93ARhDsH60ZRpEMHH_tvVC97w0Ya6KVLIy29Xi-tSX4mebVYc4yyjOouk-zeeMWv49DZmZjQp5Imh0lXVH9JoEksmoqwhiwBdsh_VpNQ7ZVHhXw')

parsed = JSON.parse(checker)

puts parsed['tracks']['items'][0]['album']['artists'][0]['name']