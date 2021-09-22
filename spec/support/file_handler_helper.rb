# frozen_string_literal: true

require 'csv'

module FileHandlerHelper
  def self.generate_csv(data, headers)
    return nil if data.nil?

    attributes = headers

    CSV.open('./spec/fixtures/files/demo.csv', 'wb') do |csv|
      csv << attributes
      data.each do |d|
        csv << attributes.map { d }
      end
    end
  end
end
