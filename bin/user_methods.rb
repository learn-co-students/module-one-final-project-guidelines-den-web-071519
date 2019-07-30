require_relative '../config/environment'
require 'pry'

def create_user
    puts "Enter your User Name."
    input = gets.chomp
    User.create(name: input)
end
def log_in
    #Pull the table of Users here.
    #give options to select a user.
    #pass a new token into user.access_token
    #pass that user_name into user_menu.
end
def welcome
    puts "Welcome to Playlister!  Would you like to log-in or create a new user?"
    puts "1. Log-in"
    puts "2. Create New"
    input = gets.chomp
    if input == '1'
        #plug in the log-in method here.
    elsif input == '2'
        create_user
        user_menu()
    else
        puts "Please enter '1' or '2'."
        welcome
    end
end

def view_playlists
    #pull playlists table
    #Option to view selected playlist
    #display_playlist
end

def user_menu (user_name)
    puts "Welcome, #{user_name}!"
    puts "What would you like to do?"
    puts "1. View Playlists"
    puts "2. Search For Songs"
    puts "3. Log-out"
    input = gets.chomp
    if input == '1'
        #plug in view_playlists method here
    elsif input == '2'
        #plug in search_menu method here
    elsif input == '3'
        welcome
    else
        puts "Enter a valid command."
    end

end

# welcome

binding.pry