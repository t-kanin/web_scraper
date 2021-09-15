# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all
  end

  def import
    Keyword.import(params[:file])
    redirect_to root_url, notice: 'Successfully imported data.'
  end
end
