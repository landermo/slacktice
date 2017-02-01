class SlackAPI
  def initialize(token)
    @token = token
  end

  def post(endpoint, parameters={})
    parameters[:token] = @token
    response = Faraday.post "https://slack.com/api/#{endpoint}", parameters

    data = JSON.parse response.body
    unless data['ok']
      raise "#{endpoint} failed: #{data['error']}"
    end
    data
  end
end

class Web

  def login_slack(email,password)

    Driver.get 'https://slack.com/signin'
    wait = Selenium::WebDriver::Wait.new timeout: 15

    # Select team domain
    team_input = Driver.find_element :id, 'domain'
    team_input.send_keys 'tiy-boomtown'

    Driver.find_element(:id, 'submit_team_domain').click

    # Fill in username and password
    Driver.find_element(:name, 'email').send_keys email

    Driver.find_element(:name, 'password').send_keys password

    buttons = Driver.find_elements :css, 'button'
    # buttons.find { ... }
    sign_in = buttons.select { |b| b.text == 'Sign in' }.first
    # sign_in.visible?
    sign_in.click
  end

  def find_channel(channel)
    # On the home page
    wait = Selenium::WebDriver::Wait.new timeout: 25
    headers = Driver.find_elements :css, 'button.channel_list_header_label'
    channel_link = wait.until do
      el = headers.find { |b| b.text.start_with? 'CHANNELS' }
      el if el && el.displayed?
    end
    channel_link.click

    # Filter down to see the channel
    Driver.find_element(:id, 'channel_browser_filter').send_keys channel

    # the link we need to click on doesn't appear until we mouse over the position
    link = Driver.find_element(:css, '.channel_link')
    Driver.mouse.move_to link
    overlay = Driver.find_element :css, '#channel_browser'
    overlay.click
  end
end
