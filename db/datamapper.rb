#Required Gems
require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-timestamps'

# DataMapper ORM
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/adserver.db")

# Creates or Upgrade all tables at once, like magic
configure :development do
  # Create or upgrade all tables at once, like magic
  DataMapper.auto_upgrade!
end

# Loads Model Classes
Dir.glob('models/*') do |model|
  require model
end