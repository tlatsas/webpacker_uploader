# frozen_string_literal: true

class WebpackerUploader::Configuration
  attr_accessor :ignored_extensions, :log_output
  attr_reader   :public_manifest_path, :public_path

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
