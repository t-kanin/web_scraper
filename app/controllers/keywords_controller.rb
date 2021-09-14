# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all
  end
end
