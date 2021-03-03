# frozen_string_literal: true

require "active_support/core_ext/object/blank"
require "active_support/logger"
require "active_support/tagged_logging"

module WebpackerUploader
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= WebpackerUploader::Instance.new
  end

  delegate :logger, :logger=, :configure, :config, :upload!, to: :instance
end

require "webpacker_uploader/configuration"
require "webpacker_uploader/instance"
require "webpacker_uploader/manifest"
require "webpacker_uploader/mime"
require "webpacker_uploader/version"
