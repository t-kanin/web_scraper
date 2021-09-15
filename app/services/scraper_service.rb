# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'

class ScraperService < ApplicationService
  attr_reader :driver, :wait, :keyword

  def initialize(keyword)
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)
    @keyword = keyword
    driver.get 'http://www.google.com/'
  end

  def call
    driver.find_element(name: 'q').send_keys keyword, :return
    total_search = wait.until { driver.find_element(id: 'result-stats').text }
    puts total_search
    retrieve_multiple_elements
  end

  def retrieve_multiple_elements
    element = driver.find_element(:id, 'search')
    elements = element.find_elements(:tag_name, 'a')

    elements.each { |e|
      puts e.text
    }
  end
end
