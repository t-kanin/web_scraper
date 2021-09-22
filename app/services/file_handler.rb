# frozen_string_literal: true

class FileHandler
  MAX_ROWS = 1001

  class FileExntensionError < StandardError; end

  class FileTooBigError < StandardError
    def message
      'File is too big'
    end
  end

  class FileEmptyError < StandardError
    def message
      'Please select file to upload'
    end
  end

  def self.handle_upload(file, uid)
    raise FileEmptyError if file.blank?
    raise FileExntensionError unless %w[.csv].include? File.extname(file)
    raise FileTooBigError if IO.readlines(file).size > MAX_ROWS

    Keyword.import(file, uid)
  end
end
