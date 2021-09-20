# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user
  has_many :search_result
  has_many :ad_result

  def self.import(file, uid)
    options = {
      required_headers: [:keyword]
    }
    SmarterCSV.process(file.path, options) do |chunk|
      Keyword.where(user_id: uid).insert_all(chunk)
    end
  end
end
