require_all './lib'
require 'tty-prompt'
require 'pastel'
require 'tty-font'
Prompt = TTY::Prompt.new
Pastel = Pastel.new
Font = TTY::Font.new(:straight)
Numbers_to_name = {5 => "five", 4 => "four", 3 => "three", 2 => "two", 1 => "one"}


def main_menu
    system("clear")
    Screen.welcome
    user_input = gets.chomp.to_i
    case user_input
    when 2..5
        number_of_players = user_input
    else
        puts "Your choices are:".rjust(90)
        puts "2 | 3 | 4 | 5".rjust(88)
        sleep(3)
        pid = fork{exec 'killall', "afplay"}
        main_menu
    end    
    system("clear")
    number_of_players.times {|player| create_player}
    start_game
end

def home_screen
    Player.destroy_all
    system("clear")
    Screen.home
    pid = fork{exec 'afplay', "./theme.mp3"}
    input = Prompt.select("", ["New Game", "Profiles", "Exit"])
    case input
    when "New Game"
        main_menu
    when "Profiles"
        profiles
    when "Exit"
        stop_music
        system("clear")
        exit
    end
end

def profiles
    system("clear")
    Screen.profile
    SavedProfile.all.each {|profile| puts "#{profile.name} | Bio: #{profile.bio} | Level: #{profile.level}".center(150)}
    profiles = SavedProfile.all.map {|profile| profile.name}
    login_choice = Prompt.select("", [profiles,"Main Menu"])
    case login_choice
    when "Main Menu"
        stop_music
        sleep(0.005)
        home_screen
    else
        if login_to_access_profile(login_choice)
            edit_profile(login_choice)
        else
            puts "Sorry, wrong password!".center(150)
            stop_music
            sleep(1.5)
            home_screen
        end
    end
end

def edit_profile(profile)
    system("clear")
    puts Pastel.green(Font.write("Welcome, #{profile}!".center(110)))
    Screen.edit_profile
    profile_linked_to_db = SavedProfile.all.select {|saved| saved.name == profile}[0]
    action = Prompt.select("Edit your profile!", ["Rename", "Change bio", "Change Password", "Delete profile :(", "Back"])
    case action 
    when "Rename"
        new_name = Prompt.ask("What is your new name?")
        profile_linked_to_db.name = new_name
        profile_linked_to_db.save
        puts "Nice to meet you #{new_name}!".center(150)
        sleep(1.5)
        edit_profile(new_name)
    when "Change bio"
        new_bio = Prompt.ask("How would you describe yourself?")
        profile_linked_to_db.bio = new_bio
        profile_linked_to_db.save
        puts "Wow, you are so cool!".center(150)
        sleep(1.5)
        edit_profile(profile)
    when "Change Password"
        new_password = Prompt.ask("Please enter your new password")
        profile_linked_to_db.password = new_password
        profile_linked_to_db.save
        puts "Password updated!".center(150)
        sleep(1.5)
        edit_profile(profile)
    when "Delete profile :("
        choice = Prompt.select("Once you delete your profile, it is gone forever! Are you Sure?", ["Yes", "No"])
        if choice == "Yes"
            profile_linked_to_db.destroy
            system("clear")
            puts "Sad to see you go!"
        end
        profiles
    else
        profiles
    end
end

def login_to_access_profile(profile)
    profile_linked_to_db = SavedProfile.all.select {|saved| saved.name == profile}[0]
    password_attempt = Prompt.mask("Please enter your password")
    if password_attempt == profile_linked_to_db.password
        return true
    else
        return false
    end
end

# PLAYER CREATION
def create_player
    Screen.player_path
    player_path = Prompt.select("", ["Create New", "Login"])
    case player_path
    when "Login"
        if SavedProfile.all.count > 0
            login
        else
            puts "There are no saved profiles! :(".center(150)
            sleep(2)
            system("clear")
            create_player
        end
    when "Create New"
        system("clear")
        Screen.new_player
        player_name = gets.chomp.to_str
        if player_name == ""
            player_name = "Steve"
        end
        if check_if_profile_logged_in(player_name)
            system("clear")
            new_player = Player.create(name: player_name)
            system("clear")
            select_weapons(new_player)
            system("clear")
            select_spells(new_player)
        else
            system("clear")
            create_player
        end
    end
end

def login
    SavedProfile.all.each {|profile| puts "#{profile.name} | Bio: #{profile.bio} | Level: #{profile.level}".center(150)}
    profiles = SavedProfile.all.map {|profile| profile.name}
    login_choice = Prompt.select("", profiles)
    if check_if_profile_logged_in(login_choice)
        login_choice_linked_to_db = SavedProfile.all.select {|profile| profile.name == login_choice}[0]
        password = Prompt.mask("Please enter your password")
        if password == login_choice_linked_to_db.password
            system("clear")
            returning_user = Player.create(name: login_choice, level: login_choice_linked_to_db.level)
            select_weapons(returning_user)
            select_spells(returning_user)
        else
            puts "Sorry, wrong password!".center(150)
            sleep(1.5)
            system("clear")
            create_player
        end
    else
        system("clear")
        create_player
    end
end

def check_if_profile_logged_in(name)
    logged_in_profiles = Player.all.map {|player| player.name}
    if logged_in_profiles.count == 0
    end
    if logged_in_profiles.include?(name)
        puts "This profile is already set to fight!".center(150)
        sleep(1.3)
        return false
    end
    return true
end

def select_weapons(player)
    puts ''
    puts ''
    puts Pastel.green(Font.write("Welcome, #{player.name}!".center(110)))
    Screen.weapon_selection
    choices = Weapon.all.map {|weapon| weapon.name}
    weapon_choices = Prompt.multi_select("", choices, max: 2, per_page: 10)
    if weapon_choices.count > 0
        weapon_one = weapon_choices[0]
        weapon_two = weapon_choices[1]
        player.weapons << Weapon.all.select {|weapon| weapon.name == weapon_one}
        player.weapons << Weapon.all.select {|weapon| weapon.name == weapon_two}
        sleep(0.5)
    else
        puts "You must have at least one weapon!"
        sleep(1)
        system("clear")
        select_weapons(player)
    end
    system("clear")
end

def select_spells(player)
    puts ''
    puts ''
    puts Pastel.green(Font.write("Welcome, #{player.name}!".center(110)))
    Screen.spell_selection
    choices = Spell.all.map {|spell| spell.name}
    spell_choice = Prompt.select("", choices)
    player.spells << Spell.all.select {|spell| spell.name == spell_choice}
    sleep(0.5)
    system("clear")
end


#PLAY GAME
def start_game
    stop_music
    sleep(0.005)
    play_battle_theme
    match
end

def match
    live_players = Player.all.select {|player| player.health > 0}
    number_of_players = live_players.count
    if number_of_players > 2
        number_of_players.times do |player_num|
            many_checker(live_players[player_num])
        end
        match
    elsif number_of_players == 2
        number_of_players.times do |player_num|
            duel_checker(live_players[player_num])
        end
        match
    elsif number_of_players == 1
        game_over
    end
end

def duel_checker(player)
    live_players = Player.all.select {|player| player.health > 0}
    number_of_players = live_players.count
    if number_of_players == 2
        refresh_screen
        turn_duel(player)
    end
end

def turn_duel(player)
    live_players = Player.all.select {|player| player.health > 0}
    target = live_players.select {|target| target.name != player.name}[0]
    puts "                                        #{player.name}, its your turn!"
    plan = Prompt.select("", ["Weapon", "Spell"])
    case plan
    when "Weapon"
        target.health -= weapon_attack(player)
        target.save
        sleep(0.5)
    when "Spell"
        use_spell(player)
    end
end

def many_checker(player)
    live_players = Player.all.select {|player| player.health > 0}
    number_of_players = live_players.count
    if number_of_players == 2
        refresh_screen
        number_of_players.times do |player_num|
            duel_checker(live_players[player_num])
        end
        match
    else
        refresh_screen
        turn_many(player)
    end
end

def turn_many(player)
    puts "                                        #{player.name}, its your turn!"
    plan = Prompt.select("", ["Weapon", "Spell"])
    case plan
    when "Weapon"
        target = choose_target(player)
        target.health -= weapon_attack(player)
        target.save
        # puts target.health
        sleep(0.5)
    when "Spell"
        use_spell(player)
    end
end

def choose_target(player)
    puts "                                        #{player.name}, choose a target!"
    live_players = Player.all.select {|player| player.health > 0}
    choices = live_players.map {|player| player.name}
    input = Prompt.select("", choices)
    target = Player.all.select {|target| target.name == input || target.id == input}[0]
    target
end

def weapon_attack(player)
    puts "                                        #{player.name}, choose a weapon!"
    puts ''
    choices = player.weapons.map {|weapon| weapon.name}
    weapon_choice = Prompt.select("", choices)
    weapon = player.weapons.select {|weapon| weapon.name == weapon_choice}[0]
    weapon.damage
end

def use_spell(player)
    spell = player.spells[0]
    puts spell.name
    case spell.name
    when "Meteor Shower"
        targets = Player.all.select {|opp| opp.name != player.name}
        targets.each do |target|
            target.health -= spell.damage
            target.save
            sleep(0.5)
        end
    when "Hugs and Kisses"
        targets = Player.all.select {|opp| opp.name != player.name}
        targets.each do |target|
            target.health += spell.health
            target.save
            sleep(0.5)
        end
    when "Expelliarmus"
        target = choose_target(player)
        target_weapons = target.weapons.map {|weapon| weapon.name}
        if target_weapons.count > 1
            weapon_remover = Prompt.select("Pick a weapon to steal!", target_weapons)
            target.weapons.each do |weapon|
                if weapon.name == weapon_remover
                    target.weapons.delete(weapon)
                end
            end
            player.weapons << Weapon.all.select {|weapon| weapon.name == weapon_remover}
        else
            puts "You cannot disarm this player, jerk!"
            sleep(2.5)
        end
    else
        target = choose_target(player)
        target.health += spell.health
        target.health -= spell.damage
        target.save
    end
    sleep(0.5)
end

def display_stats(players)
    puts "#{players.pluck(:name, :health)}".center(150)
end

def refresh_screen
    system("clear")
    live_players = Player.all.select {|player| player.health > 0}
    number_of_players = live_players.count
    puts ""
    puts ""
    display_stats(live_players)
    Screen.send(Numbers_to_name[number_of_players])
end

def stop_music
    pid = fork{exec 'killall', "afplay"}
end

def play_battle_theme
    pid = fork{exec 'afplay', "./battle.mp3"}
end



# HANDLE END OF GAME
def game_over
    stop_music
    sleep(0.005)
    pid = fork{exec 'afplay', "./theme.mp3"}
    winner = Player.all.select {|player| player.health > 0}[0]
    losers = Player.all.select {|player| player.health <= 0}
    level_up_winner(winner)
    system("clear")
    puts ""
    puts Pastel.green(Font.write("#{winner.name}".center(150)))
    Screen.one
    losers.each {|player| puts Pastel.red("#{player.name} got forked!!!".center(150))}
    if winner.level < 2
        choice = Prompt.select("Whats next #{winner.name}?", ["Save My Profile!", "Rematch", "New Game", "Exit Game"])
        case choice
        when "Save My Profile!"
            system("clear")
            Screen.edit_profile
            profile_data = Prompt.collect do 
                key(:bio).ask('Give yourself a description!')
                key(:password).mask('Set a simple password.')
            end
            profile_data[:name] = winner.name
            new_profile = SavedProfile.create(profile_data)
            puts "Profile saved!".center(150)
            sleep(2)
            stop_music
            home_screen
        when "Rematch"
            rematch
        when "New Game"
            stop_music
            home_screen
        when "Exit Game"
            stop_music
            system("clear")
            exit
        end
    else
        choice = Prompt.select("Whats next #{winner.name}?", ["Rematch", "New Game", "Exit Game"])
        case choice
        when "Rematch"
            rematch
        when "New Game"
            stop_music
            home_screen
        when "Exit Game"
            stop_music
            system("clear")
            exit
        end
    end
end

def rematch
    Player.all.each {|player| player.update(health: 100)}
    start_game
end

def level_up_winner(player)
    player.level += 1
    player.save
    player_name = player.name
    saved_player_names = SavedProfile.all.map {|player| player.name}
    if saved_player_names.include?(player_name)
        saved_player = SavedProfile.all.select{|profile| profile.name == player_name}[0]
        saved_player.level += 1
        saved_player.save
    end
end

