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
    driver.quit
  end
end
