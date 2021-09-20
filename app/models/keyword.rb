# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user
  has_many :search_result, dependent: :destroy
  has_many :ad_result, dependent: :destroy

  def self.import(file, uid)
    options = {
      required_headers: [:keyword],
      chunk_size: 10002
    }
    SmarterCSV.process(file.path, options) do |chunk|
      Keyword.where(user_id: uid).insert_all(chunk)
      key_arr = chunk.map { |k| k[:keyword] }
      ScraperWorker.perform_async(key_arr)
    end
  end
end
