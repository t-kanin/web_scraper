# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @keywords = Keyword.all
  end
end
