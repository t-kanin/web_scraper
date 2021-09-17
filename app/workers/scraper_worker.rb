# frozen_string_literal: true

class ScraperWorker
  include Sidekiq::Worker

  def perform(*args)
    ScraperService.new(args).call
  end
end
