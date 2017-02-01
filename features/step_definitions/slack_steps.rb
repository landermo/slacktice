Given(/^I am (\w+)/) do |username|
  @username = username
  puts "You are #{username}"
  token = ENV.fetch "#{username.upcase}_TOKEN"
  unless token # if !token
    raise 'Slack token not set'
  end
  @api = SlackAPI.new token
end

When(/^I send a message to \#(\w+)$/) do |channel|
  @message = Faker::Company.catch_phrase
  step "I send \"#{@message}\" to ##{channel}"
end

When(/^I send "([^"]*)" to \#(\w+)$/) do |message, channel|
  puts "Sending '#{message}' to ##{channel}"

  # Look up ID for channel
  data       = @api.post 'channels.list'
  channels   = data['channels']
  channel    = channels.select { |c| c['name'] == channel }.first
  channel_id = channel['id']

  puts "channel_id=#{channel_id}"

  # Send message
  @api.post 'chat.postMessage', {
      text:    message,
      channel: channel_id
  }
end
#
# Then(/^I should see that message on the \#(\w+) page$/) do |channel|
#   "I should see \"#{@message}\" on the ##{channel} page"
# end

Then(/^I should see that ([^"]*) on the test page$/) do |message|

  # # Look for the last message
  # messages = Driver.find_elements(:css, '.message')
  # last_message = messages.last
  #
  # expect(last_message.text).to include message

  # TODO: instead of grabbing the last message
  #   look for a message by this user, with the right text, posted "recently"
  my_message = Driver.find_element(:a, '/team/laura')
  lm = my_message.find_elements(:css, 'message_body')
  lm.find {|s| s.text == message}
  expect(lm.text).to include message

end

When(/^I send a message from the \#(\w+) page$/) do |channel|
  @message = Faker::Company.catch_phrase
  email = 'lmontgomery@boomtownroi.com'
  password = ENV.fetch "#{@username.upcase}_PASSWORD"
  slack = Web.new
  slack.login_slack(email, password)
  slack.find_channel(channel)

  slack.wait_for 'msg_input'
  Selenium::WebDriver::Wait.new timeout: 300
  textbox = Driver.find_element(:id, 'msg_input')
  textbox.click
  textbox.send_keys @message
  textbox.submit
end
