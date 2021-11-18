# frozen_string_literal: true

class WebpackerUploader::Instance
  attr_writer :config

  # @private
  def manifest
    @manifest ||= WebpackerUploader::Manifest.new
  end

  # Returns the global WebpackerUploader::Configuration object.
  # Use this to set and retrieve specific configuration options.
  #
  # @return [WebpackerUploader::Configuration]
  #
  # @example Disable log output
  #   WebpackerUploader.config.log_output = false
  #
  # @example Get the list of excluded file extension
  #   puts WebpackerUploader.config.ignored_extensions
  #
  # @example Get the cache control header
  #   #   puts WebpackerUploader.config.cache_control
  #
  # @see WebpackerUploader::Configuration
  def config
    @config ||= WebpackerUploader::Configuration.new
  end

  # Yields the global configuration to a block. Use this to
  # configure the base gem features.
  #
  # @example
  #   WebpackerUploader.configure do |config|
  #     config.ignored_extensions = [".png", ".jpg", ".webp"]
  #     config.cache_control = "max-age=31536000"
  #     config.log_output = false
  #     config.public_manifest_path = "path/to/manifest.json"
  #     config.public_path = "path/to/public/dir"
  #   end
  #
  # @see WebpackerUploader::Configuration
  def configure
    yield config
  end

  # Uploads assets using the supplied provider. Currently only AWS S3 is implemented.
  #
  # @return [void]
  # @param provider [WebpackerUploader::Providers::Aws] A provider to use for file uploading.
  # @param prefix [String] Used to prefix the remote file paths.
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
        config.logger.info("Skipping #{file_path}") if config.log_output?
      else
        content_type = WebpackerUploader::Mime.mime_type(path)

        config.logger.info("Processing #{file_path} as #{content_type} with cache_control=#{config.cache_control}") if config.log_output?

        provider.upload!(remote_path, file_path, content_type, config.cache_control)
      end
    end
  end
end
