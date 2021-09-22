# frozen_string_literal: true

class Keyword < ApplicationRecord
  CHUNK_SIZE = 1002

  belongs_to :user
  has_many :search_results, dependent: :destroy
  has_many :ad_results, dependent: :destroy

  def self.import(file, uid)
    options = {
      required_headers: [:keyword],
      chunk_size: CHUNK_SIZE
    }
    SmarterCSV.process(file.path, options) do |chunk|
      Keyword.where(user_id: uid).insert_all(chunk)
      ScraperWorker.perform_async(chunk.map { |arr| arr[:keyword] })
    end
  end
end
