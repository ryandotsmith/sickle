require 'bundler'
Bundler.require

#QC::Database.database = ENV["QUEUE_DB"]
DB = Sequel.connect(ENV["DATABASE_URL"])

unless DB.table_exists? :accounts
  DB.create_table :accounts do
    primary_key :id
    Integer :default_queue_id
    String :username
    String :password
  end
end


unless DB.table_exists? :queues
  DB.create_table :queues do
    primary_key :id
    Integer :account_id
    String :url
    String :name
  end
end

require './sickle_app'


use Rack::Auth::Basic do |username, password|
  username == 'sickle' && password == 'jHTbTrJtBry8WZIl'
end

run SickleApp
