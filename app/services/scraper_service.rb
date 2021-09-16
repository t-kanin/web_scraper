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
    [page_result, search_result]
  end

  def search_result
    res = []
    elements = doc.css('div.g')
    elements.pop
    elements.each do |e|
      h = { title: e.css('h3').text, link: e.css('a @href').first.text }
      res << h
    end
    res
  end

  def page_result
    doc.at_css('div#result-stats').text
  end
end
