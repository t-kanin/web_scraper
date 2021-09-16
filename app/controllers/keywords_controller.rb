# frozen_string_literal: true

class KeywordsController < ApplicationController
  def index
    @keywords = Keyword.all
  end

  def import
    file = params[:file]
    FileHandler.handle_upload(file, current_user.id)
    redirect_to root_url, notice: 'Successfully imported data.'
  rescue FileHandler::FileEmptyError => e
    redirect_to root_url, alert: e.message
  rescue FileHandler::FileTooBigError => e
    redirect_to root_url, alert: e.message
  rescue SmarterCSV::MissingHeaders
    redirect_to root_url, alert: 'Missing require headers'
  rescue ActiveModel::UnknownAttributeError
    redirect_to root_url, alert: 'Headers not match'
  end
end
