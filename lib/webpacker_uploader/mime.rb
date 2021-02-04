# frozen_string_literal: true

require "mime-types"

module WebpackerUploader::Mime
  def mime_type(file_path)
    fallback = MIME::Types.type_for(file_path).first&.content_type || "application/octet-stream"
    Rack::Mime.mime_type(File.extname(file_path), fallback)
  end
  module_function :mime_type
end
