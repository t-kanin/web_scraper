# frozen_string_literal: true

class ScraperWorker
  include Sidekiq::Worker

  def perform(keywords)
    ScraperService.instance.call(keywords)
  end
end
