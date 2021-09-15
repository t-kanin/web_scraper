# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  def self.import(file, uid)
    options = {}
    SmarterCSV.process(file.path, options) do |chunk|
      chunk.each do |data_hash|
        data_hash[:user_id] = uid
        p data_hash
        Keyword.create!(data_hash)
      end
    end
  end
end
