Given(/^I'm on the home page$/) do
  @web = Boomtown::Web.new
  @web.visit '/'
end

When(/^I search for "([^"]*)"$/) do |q|
  @web.search_for q
end

Then(/^"([^"]*)" appears in the filter list$/) do |term|
  # tags = @web.find '.bt-search-tags'
  # spans = tags.find_elements css: 'span'
  spans = @web.find_all '.bt-search-tags span'
  tag = spans.find { |s| s.text == "Keyword: \"#{term}\"" }

  expect(tag).not_to eq nil
end

And(/^there are at least (\d+) results$/) do |count|
  results = @web.wait_for '.results-paging'
  expect(results.text.to_i).to be > count.to_i
end

And(/^each result is in (.*)$/) do |location|
  links = @web.find_all 'a.at-related-props-card'
  # a .at-related-props-card - things with class inside a tags
  # a.at-related-props-card - a tags with class ...
  locations = links.map { |l| l.attribute :href }
end

And(/^I click "([^"]*)"$/) do |button|
  a = @web.wait_for 'a.js-save-search'
  text = a.find{ |s| s.text == "#{button}"}
  text.click
end

And(/^I complete registration$/) do
  @my_email = Faker::Internet.email
  @name = Faker::StarWars.character

  form = @web.wait_for'.js-register-form'
  i = form.find_element(:name, 'email')
  i.send_keys @my_email
  @web.find('.bt-squeeze__button').click

  register = @web.wait_for '.js-complete-register-form'
  fullname = register.find_element(:name, 'fullname')
  fullname.send_keys @name
  phone = register.find_element(:name,'phone')
  phone.send_keys '843-555-5555'
  reg = @web.find('button.at-submit-btn')
  reg.click

  @web.wait_for 'a.js-signout'
end

And(/^I name a search$/) do |name|
  form = @web.wait_for '#save-search-form'
  i = form.find_element(:name, 'searchName')
  i.send_keys name
end

Then(/^I see my saved search$/) do
  pending
end

And(/^I have a user account$/) do
  pending
end