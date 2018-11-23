namespace :bot do
  desc "Run super bot in infinite loop"
  task run: :environment do
    PongBot.run
  end
end
