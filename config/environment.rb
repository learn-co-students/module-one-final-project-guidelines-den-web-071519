require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'


# puts 'enter pry? (y/n)'
# key = gets.chomp
# if key == 'y'
#     binding.pry
# end

# binding.pry