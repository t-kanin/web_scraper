# frozen_string_literal: true

class FileHandler
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
    raise FileEmptyError if file.nil?
    raise FileExntensionError unless %w[.csv].include? File.extname(file)
    raise FileTooBigError if IO.readlines(file).size > 1001

    Keyword.import(file, uid)
  end
end
