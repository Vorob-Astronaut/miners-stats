require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'
require 'rest-client'
require "selenium-webdriver"
require 'watir'

# MAIN_PAGE = 'https://eth.2miners.com/en/miners'

# url = 'https://btg.2miners.com/api/miners'
# response = RestClient.get(url, headers={})
# miners = JSON.parse(response.body)['miners'].keys

# miners.each do |wallet_id|
#   info_url = "https://btg.2miners.com/api/accounts/#{wallet_id}"
#   response = RestClient.get(info_url, headers={})  
#   data = JSON.parse(response.body)
#   binding.pry
# end
# Fetch and parse HTML document
# doc = Nokogiri::HTML(open(MAIN_PAGE))
driver = Selenium::WebDriver.for :chrome
# browser = Watir::Browser.new :chrome
existing_accounts = CSV.read('data.csv').map {|e| e[0] }

CSV.foreach("/Users/egorvorobiev/Downloads/miners.csv") do |row|
  url = row.last
  account_id = url.split('/').last

  if existing_accounts.include?(account_id)
    p 'SKIPPED ' + account_id 
    next
  end

  driver.navigate.to url
  elements = driver.find_elements(class: 'textfill')

  total_paid = elements[2].text  
  average_rate = elements[6].text

  CSV.open("data.csv", "ab") do |csv|
    csv << [account_id, total_paid, average_rate]
  end
end
# puts "### Search for nodes by css"
# doc.css('nav ul.menu li a', 'article h2').each do |link|
#   puts link.content
# end

# puts "### Search for nodes by xpath"
# doc.xpath('//nav//ul//li/a', '//article//h2').each do |link|
#   puts link.content
# end

# puts "### Or mix and match."
# doc.search('nav ul.menu li a', '//article//h2').each do |link|
#   puts link.content
# end