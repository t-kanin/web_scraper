# frozen_string_literal: true

class KeywordsController < ApplicationController
  rescue_from FileHandler::FileExntensionError, with: :file_invalid
  rescue_from FileHandler::FileEmptyError, with: :file_invalid
  rescue_from FileHandler::FileTooBigError, with: :file_invalid

  def index
    @keywords = current_user.keywords
  end

  def import
    file = params[:file]
    FileHandler.handle_upload(file, current_user.id)
    redirect_to root_url, notice: 'Successfully imported data.'
  rescue SmarterCSV::MissingHeaders
    redirect_to root_url, alert: 'Missing require headers'
  rescue ActiveModel::UnknownAttributeError
    redirect_to root_url, alert: 'Headers not match'
  end

  private

  def file_invalid(exception)
    redirect_to root_url, alert: exception.message
  end
end
