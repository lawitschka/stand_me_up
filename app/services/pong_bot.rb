class PongBot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    # client.say(text: '*pong*', channel: data.channel)
    client.files_upload(
      channels: data.channel,
      as_user: true,
      file: Faraday::UploadIO.new(Rails.root.join('README.md'), 'application/txt'),
      title: 'Blow your mind',
      filename: '',
      initial_comment: 'Hey!'
    )
  end
end
