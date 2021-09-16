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
    raise FileTooBigError if file.size > 1000.megabytes
    raise FileExntensionError unless %w[csv].include?(file.extension)

    Keyword.import(file, uid)
  end
end
