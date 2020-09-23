# frozen_string_literal: true

module WebpackerUploader
  class Manifest
    include Singleton

    IGNORE_EXTENSION = %w[.map].freeze
    public_constant :IGNORE_EXTENSION

    attr_reader :assets

    def initialize
      manifest_contents = IO.read(Webpacker.config.public_manifest_path)
      @assets = JSON.parse(manifest_contents).except("entrypoints")
    end

    def upload!(provider, logger: Rails.logger)
      @assets.each do |name, path|
        path = path[1..-1]
        file_path = Rails.root.join("public", path)

        if name.end_with?(*IGNORE_EXTENSION)
          logger.info("Skipping: #{file_path}")
        else
          logger.info("Processing: #{file_path}")
          provider.upload!(path, file_path, content_type_for(path)) unless name.end_with?(*IGNORE_EXTENSION)
        end
      end
    end

    def content_type_for(file)
      fallback = MIME::Types.type_for(file).first.content_type
      Rack::Mime.mime_type(File.extname(file), fallback)
    end
  end
end
