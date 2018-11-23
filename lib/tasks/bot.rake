namespace :bot do
  desc "Run super bot in infinite loop"
  task run: :environment do
    client = Slack::RealTime::Client.new
    client.on :hello do
      puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
    end

    client.on :message do |data|
      case data.text
      when /^bot standup/ then
        client.message channel: data.channel, text: "Processing ..."
        text = data.text
        team_name = data.text.split(" ").last

        markdown = TemplateGenerator.generate(team_name)

        client.message channel: data.channel, text: "*Hi* <@#{data.user}>! Let me tell you who is going to take notes and who will drive ... :8ball:"

        team = ['Boris', 'Geogre', 'Moritz', 'Simao', 'Ben', 'Joshan', 'Sara', 'Orcun', 'Serena', 'Jason']
        taking_notes = driving = team.sample(2)

        client.message channel: data.channel, text: "#{driving} will drive today and #{taking_notes} will take notes!"

        client.web_client.files_upload(
          channels: '#slack-skynet-bot-team',
          as_user: true,
          # file: Faraday::UploadIO.new("daily-notes.md", 'text/markdown'),
          content: markdown,
          title: 'Daily Notes',
          filename: 'daily-notes.md',
          filetype: 'markdown',
          initial_comment: 'Make your daily notes ...'
        )
      when /^bot/ then
        client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
      end
    end
    client.start!
  end
end
