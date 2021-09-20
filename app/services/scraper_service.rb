# frozen_string_literal: true

class ScraperService < ApplicationService
  include Singleton

  def call(keywords)
    key_res = []
    driver = init_driver
    keywords.each do |keyword|
      res = result(driver, keyword)
      driver.find_element(name: 'q').clear
      key_res << res
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
      res << { title: e.css(title).text, link: e.css(link).first.text } unless e.css(title).blank?
    end

    res
  end

  def page_result(doc)
    doc.at_css('div#result-stats').text
  end
end
