require_relative '../config/environment'
require 'pry'
    current_user = nil
    def create_user
        puts "Enter your User Name."
        input = gets.chomp
        User.create(name: input)
    end
    def log_in
        puts "Select a user to log into"
        User.all.each_with_index{|user, index| puts "#{index}. #{user.name}"}
        input = gets.chomp
        $current_user = User.find_by(id: input)
    end
    def welcome
        puts "Welcome to Playlister!  Would you like to log-in or create a new user?"
        puts "1. Log-in"
        puts "2. Create New"
        input = gets.chomp
        if input == '1'
            log_in
        elsif input == '2'
            $current_user = create_user
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

    def user_menu (current_user)
        puts "Welcome, #{current_user.name}"
        puts "What would you like to do?"
        puts "1. View Playlists"
        puts "2. Create Playlist"
        puts "3. Search For Songs"
        puts "4. Log-out"
        input = gets.chomp
        if input == '1'
            #plug in view_playlists method here
        elsif input == '2'
            #plug in create_playlist method here
        elsif input == '3'
            #plug in search_any method here
        elseif input == '4'
            welcome
        else
            puts "Enter a valid command."
        end

    end

    # welcome

    binding.pry