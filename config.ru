require 'bundler'
Bundler.require

DB = Sequel.connect(ENV["DATABASE_URL"])

unless DB.table_exists? :accounts
  DB.create_table :accounts do
    primary_key :id
    Integer :default_queue_id
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

run SickleApp
