# frozen_string_literal: true

class Keyword < ApplicationRecord
  belongs_to :user

  def self.import(file, uid)
    SmarterCSV.process(file.path, {}) do |chunk|
      Keyword.where(user_id: uid).insert_all(chunk)
    end
  end
end
