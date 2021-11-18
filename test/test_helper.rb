# frozen_string_literal: true

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "webpacker"
require "webpacker_uploader"

module TestApp
  class Application < ::Rails::Application
    config.root = File.join(File.dirname(__FILE__), "test_app")
    config.eager_load = true
  end
end

TestApp::Application.initialize!

module WebpackerUploader::Providers
  class TestProvider
    def initialize(asset_objects)
      @asset_objects = asset_objects
    end

    def upload!(object_key, file, content_type = "", cache_control)
      @asset_objects << { object_key: object_key, file: file, content_type: content_type, cache_control: cache_control }
    end
  end
end

module WebpackerUploader
  def reset!
    WebpackerUploader.instance.config = nil
  end
  module_function :reset!
end
