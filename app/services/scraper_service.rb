# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'

class ScraperService < ApplicationService
  include Singleton
  
  def call(keyword)
    key_res = []
    driver = init_driver
    keywords.each do |keyword|
      driver.find_element(name: 'q').send_keys keyword, :return
      doc = Nokogiri::HTML(driver.page_source)
      res = {
        page_result: page_result(doc),
        search_result: search_result(doc),
        ad_result: ad_result(doc)
      }
      driver.find_element(name: 'q').clear
      key_res << res
    end

    key_res
  end

  def init_driver
    driver = Selenium::WebDriver.for :chrome
    driver.get 'http://www.google.com/'
    driver
  end

  def search_result(doc)
    res = []
    elements = doc.css('div.g')
    elements.pop
    elements.each do |e|
      h = { title: e.css('h3').text, link: e.css('a @href').first.text }
      res << h
    end
    res
  end

  def ad_result(doc)
    res = []
    elements = doc.css('div#tads a')
    elements.each do |e|
      title = e.css('span').first
      next if title.nil?

      h = { title: title.text, link: e.css('@href').first.text }
      res << h
    end
    res
  end

  def page_result(doc)
    doc.at_css('div#result-stats').text
  end
end
