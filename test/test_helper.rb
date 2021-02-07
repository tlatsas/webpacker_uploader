# frozen_string_literal: true

require "minitest/autorun"
require "rails"
require "rails/test_help"
require "webpacker"
require "webpacker_uploader"

WebpackerUploader.instance = WebpackerUploader::Instance.new

class WebpackerUploader::Test < Minitest::Test
  private
    def with_ignored_extensions_config(ignored_extensions)
      original = WebpackerUploader.instance.ignored_extensions
      WebpackerUploader.instance.ignored_extensions = ignored_extensions
      yield
    ensure
      WebpackerUploader.instance.ignored_extensions = original
    end
end

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

    def upload!(object_key, file, content_type = "")
      @asset_objects << { object_key: object_key, file: file, content_type: content_type }
    end
  end
end
