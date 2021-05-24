# frozen_string_literal: true

require "active_support/core_ext/object/blank"

module WebpackerUploader
  extend self

  # @private
  def instance=(instance)
    @instance = instance
  end

  # @private
  def instance
    @instance ||= WebpackerUploader::Instance.new
  end

  # @!attribute [rw] config
  #   @see Instance#config
  #   @!scope class
  # @!method configure
  #   @see Instance#configure
  #   @!scope class
  # @!method upload!
  #   @return [void]
  #   @see Instance#upload!
  #   @!scope class
  delegate :configure, :config, :upload!, to: :instance
end

require "webpacker_uploader/configuration"
require "webpacker_uploader/instance"
require "webpacker_uploader/manifest"
require "webpacker_uploader/mime"
require "webpacker_uploader/version"
