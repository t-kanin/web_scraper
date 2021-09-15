# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'

class ScraperService < ApplicationService
  attr_reader :driver, :wait

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 10)

  end

  def call
    begin
      driver.get 'https://google.com/ncr'
      driver.find_element(name: 'q').send_keys 'cheese', :return
      first_result = wait.until { driver.find_element(css: 'h3') }
      puts first_result.attribute('textContent')
    ensure
      driver.quit
    end
  end
end
