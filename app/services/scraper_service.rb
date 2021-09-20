# frozen_string_literal: true

class ScraperService < ApplicationService
  include Singleton

  def call(keywords)
    key_res = []
    driver = init_driver
    keywords.each do |keyword|
      scraper_res = result(driver, keyword)
      update_database(keyword, scraper_res)
      driver.find_element(name: 'q').clear
      key_res << scraper_res
    end

    driver.quit
    key_res
  end

  def init_driver
    driver = Selenium::WebDriver.for :chrome
    driver.get 'http://www.google.com/'
    driver
  end

  def result(driver, keyword)
    driver.find_element(name: 'q').send_keys keyword, :return
    doc = Nokogiri::HTML(driver.page_source)
    {
      page_result: page_result(doc),
      search_result: search(doc, 'div.g', 'h3', 'a @href'),
      ad_result: search(doc, 'div#tads a', 'span', '@href')
    }
  end

  def search(doc, div, title, link)
    res = []
    elements = doc.css(div)
    elements.each do |e|
      res << { title: e.css(title).text, url: e.css(link).first.text } unless e.css(title).blank?
    end

    res
  end

  def page_result(doc)
    doc.at_css('div#result-stats').text
  end

  def update_database(key, res)
    Keyword.where(keyword: key).update(page_result: res[:page_result])
    kid = Keyword.where(keyword: key).last.id
    SearchResult.where(keyword_id: kid).insert_all(res[:search_result]) unless res[:search_result].empty?
    AdResult.where(keyword_id: kid).insert_all(res[:ad_result]) unless res[:ad_result].empty?
  end
end
