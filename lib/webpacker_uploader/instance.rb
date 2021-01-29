# frozen_string_literal: true

require "mime-types"

class WebpackerUploader::Instance
  DEFAULT_IGNORE_EXTENSION = %w[.map].freeze

  cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }
  cattr_accessor(:ignored_extensions) { %w[.map] }

  def manifest
    @manifest ||= WebpackerUploader::Manifest.new
  end

  def upload!(provider, prefix: nil)
    extensions_to_ignore = if ignored_extensions.nil? || !ignored_extensions.is_a?(Array)
                             logger.warning('Ignored extensions should be specified as an array.')
                             logger.warning("Ignoring #{DEFAULT_IGNORE_EXTENSION} instead")

                             DEFAULT_IGNORE_EXTENSION
                           else
                             ignored_extensions
                           end

    manifest.assets.each do |name, js_path|
      path = js_path[1..-1]
      remote_path = "#{prefix}/#{path}" unless prefix.nil?
      file_path = Rails.root.join("public", path)

      if name.end_with?(*extensions_to_ignore)
        logger.info("Skipping: #{file_path}")
      else
        logger.info("Processing: #{file_path}")

        unless name.end_with?(*extensions_to_ignore)
          provider.upload!(path, file_path, content_type_for(path))
        end
      end
    end
  end

  private

    def content_type_for(file)
      fallback = MIME::Types.type_for(file).first.content_type
      Rack::Mime.mime_type(File.extname(file), fallback)
    end
end
