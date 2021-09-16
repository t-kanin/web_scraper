# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all
  end

  def import
    Keyword.import(params[:file], current_user.id)
    redirect_to root_url, notice: 'Successfully imported data.'
  rescue SmarterCSV::MissingHeaders
    redirect_to root_url, alert: 'Missing require headers'
  end
end
