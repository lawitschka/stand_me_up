namespace :bot do
  desc "Run super bot in infinite loop"
  task run: :environment do
    client = Slack::RealTime::Client.new
    client.on :hello do
      puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
    end

    client.on :message do |data|
      case data.text
      when 'bot hi' then
        client.message channel: data.channel, text: "Hi <@#{data.user}>!"
        client.web_client.files_upload(
          channels: '#slack-skynet-bot-team',
          as_user: true,
          file: Faraday::UploadIO.new("daily-notes.md", 'application/txt'),
          title: 'Daily Notes',
          filename: 'daily-notes.txt',
          filetype: 'post',
          initial_comment: 'Make your daily notes ...'
        )
      when /^bot/ then
        client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
      end
    end
    client.start!
  end
end
