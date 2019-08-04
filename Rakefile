require_relative './config/environment'
require 'sinatra/activerecord/rake'

task :environment do
  ENV["ACTIVE_RECORD_ENV"] ||= "development"
  require_relative './config/environment'
end

task :console => :environment do
  Pry.start
end