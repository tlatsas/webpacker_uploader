# frozen_string_literal: true

class WebpackerUploader::Instance
  cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

  attr_writer :config

  def manifest
    @manifest ||= WebpackerUploader::Manifest.new
  end

  def config
    @config ||= WebpackerUploader::Configuration.new
  end

  def configure
    yield config
  end

  def upload!(provider, prefix: nil)
    manifest.assets.each do |name, js_path|
      path = js_path[1..-1]

      remote_path =
        if prefix.nil?
          path
        else
          "#{prefix}/#{path}"
        end

      file_path = config.public_path.join(path)

      if name.end_with?(*config.ignored_extensions)
        logger.info("Skipping #{file_path}") if config.log_output?
      else
        content_type = WebpackerUploader::Mime.mime_type(path)

        logger.info("Processing #{file_path} as #{content_type}") if config.log_output?

        provider.upload!(remote_path, file_path, content_type)
      end
    end
  end
end
