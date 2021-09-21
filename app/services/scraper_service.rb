# frozen_string_literal: true

class ScraperService < ApplicationService
  include Singleton

  def call(keywords)
    init_driver
    keywords.each do |keyword|
      store_result(keyword, result(keyword))
      @driver.find_element(name: 'q').clear
      sleep rand(1...15)
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
    @dic.css('div#tads').map { |link| { title: link.css('div a span').first.text, url: link.css('@href').first.text } }
        .reject { |h| h[:title].empty? }
  end

  def fetch_non_adwords_links
    @dic.css('div.g').map { |link| { title: link.css('h3').text, url: link.css('a @href').first.text } }
        .reject { |h| h[:title].empty? }
  end

  def page_result
    return 'no results containing your search terms' if @dic.at_css('div#result-stats').nil?

    @dic.at_css('div#result-stats').text
  end

  def store_result(key, res)
    return if res[:page_result].nil?

    Keyword.where(keyword: key).update(page_result: res[:page_result])
    id = Keyword.where(keyword: key).last.id
    SearchResult.where(keyword_id: id).insert_all(res[:search_result]) if res[:search_result].present?
    AdResult.where(keyword_id: id).insert_all(res[:ad_result]) if res[:ad_result].present?
  end
end
