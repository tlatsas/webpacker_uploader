# frozen_string_literal: true

# This is the class which holds the configuration options.
#
# Options are set and retrieved using `WebpackerUploader.config`
# and `WebpackerUploader.configure`.
class WebpackerUploader::Configuration
  # @return [Array] the file extentions ignored by the uploader.
  attr_accessor :ignored_extensions

  # @return [Boolean] whether or not to log operations.
  attr_accessor :log_output

  # @return [Pathname] the path to manifest.json, defaults to Webpacker public manifest path.
  attr_reader :public_manifest_path

  # @return [Pathname] the public root path, defaults to Webpacker public root path.
  attr_reader :public_path

  alias_method :log_output?, :log_output

  def initialize
    @ignored_extensions = []
    @log_output = true
    @public_manifest_path = ::Webpacker.config.public_manifest_path
    @public_path = ::Webpacker.config.public_path
  end

  def public_manifest_path=(path)
    @public_manifest_path = Pathname.new(path)
  end

  def public_path=(path)
    @public_path = Pathname.new(path)
  end
end
