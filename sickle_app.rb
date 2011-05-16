class SickleApp < Sinatra::Application

  get "/" do
    "sickle".to_json
  end

  post "/heroku/resources" do
    account = Sickle::Account.create
    {:id => account.id, :config => {"SICKLE_URL" => account.default_queue.url}}.to_json
  end

end

module Sickle
  class Queue < Sequel::Model
    QMAN_HOST = "qman.heroku.com"

    def after_create
      create_backend_queue
    end

    def create_backend_queue
      QC::Database.create_queue(unique_queue_name)
    end

    def unique_queue_name
      "queue_#{self.id}"
    end

    def url
      "https://" + account.username + ":" + account.password + "@" +  QMAN_HOST
    end

    def account
      @account ||= Account[account_id]
    end

  end

  class Account < Sequel::Model

    def after_create
      super
      queue = Queue.create(:name => "default_queue", :account_id => self.id)
      self.default_queue_id = queue.id
      self.username = "user"
      self.password = "pass"
      self.save
    end

    def default_queue
      Queue[default_queue_id]
    end

  end

end
