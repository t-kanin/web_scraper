# frozen_string_literal: true

class ScraperService < ApplicationService
  include Singleton

  def call(keywords)
    init_driver
    result = keywords.each_with_object([]) do |keyword, accum|
      res = result(keyword)
      @driver.find_element(name: 'q').clear
      accum << res
    end

    @driver.quit
    result
  end

  def init_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    @driver = Selenium::WebDriver.for :chrome, options: options
    @driver.get 'http://www.google.com/'
    @driver
  end

  def result(keyword)
    @driver.find_element(name: 'q').send_keys keyword, :return
    @dic = Nokogiri::HTML(@driver.page_source)
    {
      page_result: page_result,
      search_result: fetch_non_adwords_links,
      ad_result: fetch_top_position_adwords_links
    }
  end

  def fetch_top_position_adwords_links
    @dic.css('div#tads a').map { |link| { title: link.css('div span').text, link: link.css('@href').first.text } }
        .reject { |h| h[:title].empty? }
  end

  def fetch_non_adwords_links
    @dic.css('div.g').map { |link| { title: link.css('h3').text, link: link.css('a @href').first.text } }
        .reject { |h| h[:title].empty? }
  end

  def page_result
    @dic.at_css('div#result-stats').text
  end
end
