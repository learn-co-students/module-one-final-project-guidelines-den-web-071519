require_relative '../config/environment'
require 'pry'

def create_user(user_name)
    User.new(user_name)
end

binding.pry