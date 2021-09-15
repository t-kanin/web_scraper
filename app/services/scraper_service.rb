# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'

class ScraperService < ApplicationService
  attr_reader :doc

  def initialize(keyword)
    driver = Selenium::WebDriver.for :chrome
    driver.get 'http://www.google.com/'
    driver.find_element(name: 'q').send_keys keyword, :return
    @doc = Nokogiri::HTML(driver.page_source)
  end

  def call
    p page_result
    all_search_result
    nil
  end

  def all_search_result
    elements = doc.css('div.g')
    elements.each do |e|
      p e.css('h3')
      p '******************************************************************************'
    end
  end

  def page_result
    doc.at_css('div#result-stats').text
  end
end
