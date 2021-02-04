# frozen_string_literal: true

class WebpackerUploader::Instance
  cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }
  cattr_accessor(:ignored_extensions) { %w[.map] }

  def manifest
    @manifest ||= WebpackerUploader::Manifest.new
  end

  def upload!(provider, prefix: nil)
    if ignored_extensions.nil?
      raise ArgumentError, "Ignored extensions should be specified as an array"
    end

    manifest.assets.each do |name, js_path|
      path = js_path[1..-1]

      remote_path =
        if prefix.nil?
          path
        else
          "#{prefix}/#{path}"
        end

      file_path = Rails.root.join("public", path)

      if name.end_with?(*ignored_extensions)
        logger.info("Skipping #{file_path}")
      else
        content_type = WebpackerUploader::Mime.mime_type(path)
        logger.info("Processing #{file_path} as #{content_type}")

        provider.upload!(remote_path, file_path, content_type)
      end
    end
  end
end
