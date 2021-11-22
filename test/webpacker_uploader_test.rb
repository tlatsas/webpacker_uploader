# frozen_string_literal: true

require "test_helper"

class WebpackerUploaderTest < Minitest::Test
  def setup
    @asset_objects = []
    @provider = WebpackerUploader::Providers::TestProvider.new(@asset_objects)

    WebpackerUploader.config.log_output = false
  end

  def teardown
    WebpackerUploader.reset!
  end

  def test_upload
    WebpackerUploader.upload!(@provider)

    assert_equal "packs/bootstrap-c38deda30895059837cf.css", @asset_objects.first[:object_key]
    assert_instance_of Pathname, @asset_objects.first[:file]
    assert_equal "text/css", @asset_objects.first[:content_type]
  end

  def test_upload_with_prefix
    WebpackerUploader.upload!(@provider, prefix: "prefix")

    assert_equal "prefix/packs/bootstrap-c38deda30895059837cf.css", @asset_objects.first[:object_key]
    assert_instance_of Pathname, @asset_objects.first[:file]
    assert_equal "text/css", @asset_objects.first[:content_type]
  end

  def test_upload_with_cache_control
    WebpackerUploader.upload!(@provider, cache_control: "cache_control")
    puts @asset_objects
    assert_equal "cache_control", @asset_objects.first[:cache_control]
  end
end
