# frozen_string_literal: true

require "mime-types"

module WebpackerUploader::Mime
  # Returns the mime type for the given file in the filesystem.
  # If it's unable to detect the mime type, it returns +application/octet-stream+
  # as a fallback.
  #
  # @param file_path [String] A file path in the local filesystem.
  # @return [String] The file mime type.
  def mime_type(file_path)
    fallback = MIME::Types.type_for(file_path).first&.content_type || "application/octet-stream"
    Rack::Mime.mime_type(File.extname(file_path), fallback)
  end
  module_function :mime_type
end
