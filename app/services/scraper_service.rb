# frozen_string_literal: true

class ScraperService < ApplicationService
  include Singleton

  def call(keywords)
    init_driver
    keywords.each do |keyword|
      update_database(keyword, result(keyword))
      @driver.find_element(name: 'q').clear
    end

    @driver.quit
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
    @dic.css('div#tads a').map { |link| { title: link.css('div span').first.text, url: link.css('@href').first.text } }
        .reject { |h| h[:title].empty? }
  end

  def fetch_non_adwords_links
    @dic.css('div.g').map { |link| { title: link.css('h3').text, url: link.css('a @href').first.text } }
        .reject { |h| h[:title].empty? }
  end

  def page_result
    @dic.at_css('div#result-stats').text
  end

  def update_database(key, res)
    Keyword.where(keyword: key).update(page_result: res[:page_result])
    kid = Keyword.where(keyword: key).last.id
    SearchResult.where(keyword_id: kid).insert_all(res[:search_result]) unless res[:search_result].empty?
    AdResult.where(keyword_id: kid).insert_all(res[:ad_result]) unless res[:ad_result].empty?
  end
end
