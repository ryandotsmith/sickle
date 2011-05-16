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
  end

  class Account < Sequel::Model

    def after_create
      super
      queue = Queue.create(:name => "default_queue", :url => "https://ryan:pass@sickle.heroku.com")
      self.default_queue_id = queue.id
      self.save
    end

    def default_queue
      Queue[default_queue_id]
    end
  end

end
