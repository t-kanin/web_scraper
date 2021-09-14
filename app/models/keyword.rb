# frozen_string_literal: true

class Keyword < ApplicationRecord
  def self.import(file)
    options = {}
    SmarterCSV.process(file.path, options) do |chunk|
      chunk.each do |data_hash|
        Keyword.create!(data_hash)
      end
    end
  end
end
