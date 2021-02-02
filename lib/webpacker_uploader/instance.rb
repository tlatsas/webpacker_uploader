# frozen_string_literal: true

require "mime-types"

class WebpackerUploader::Instance
  # TODO make this configurable
  IGNORE_EXTENSION = %w[.map].freeze
  public_constant :IGNORE_EXTENSION

  cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

  def manifest
    @manifest ||= WebpackerUploader::Manifest.new
  end

  def upload!(provider, prefix: nil)
    manifest.assets.each do |name, js_path|
      path = js_path[1..-1]
      remote_path = "#{prefix}/#{path}" unless prefix.nil?

      file_path = Rails.root.join("public", path)

      if name.end_with?(*IGNORE_EXTENSION)
        logger.info("Skipping: #{file_path}")
      else
        logger.info("Processing: #{file_path}")
        provider.upload!(remote_path, file_path, content_type_for(path)) unless name.end_with?(*IGNORE_EXTENSION)
      end
    end
  end

  private

    def content_type_for(file)
      fallback = MIME::Types.type_for(file).first.content_type
      Rack::Mime.mime_type(File.extname(file), fallback)
    end
end
