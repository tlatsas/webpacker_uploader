# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @config = WebpackerUploader::Configuration.new
  end

  def teardown
    WebpackerUploader.reset!
  end

  def test_default_config_options
    assert_empty @config.ignored_extensions

    assert_empty @config.cache_control

    assert_instance_of ActiveSupport::Logger, @config.logger

    assert @config.log_output
    assert @config.log_output?

    public_manifest_path = Pathname.new(File.expand_path("test_app/public/packs/manifest.json", __dir__))
    assert_equal public_manifest_path, @config.public_manifest_path

    public_path = Pathname.new(File.expand_path("test_app/public/", __dir__))
    assert_equal public_path, @config.public_path
  end

  def test_changing_config_options
    @config.ignored_extensions = [".css", ".js"]
    assert_equal [".css", ".js"], @config.ignored_extensions

    @config.cache_control = "max-age=31536000"
    assert_equal "max-age=31536000", @config.cache_control

    @config.logger = Logger.new(STDOUT)
    assert_instance_of Logger, @config.logger

    @config.log_output = false
    refute @config.log_output
    refute @config.log_output?

    @config.public_manifest_path = "test_app/manifest.json"
    assert_equal "test_app/manifest.json", @config.public_manifest_path.to_s

    @config.public_path = "test_app"
    assert_equal "test_app", @config.public_path.to_s
  end

  def test_configure_block
    WebpackerUploader.configure do |c|
      c.ignored_extensions = [".js"]
      c.cache_control = "max-age=31536000"
      c.logger = Logger.new(STDOUT)
      c.log_output = false
      c.public_manifest_path = "path/to/manifest.json"
      c.public_path = "path/to/public/dir"
    end

    assert_equal [".js"], WebpackerUploader.config.ignored_extensions
    assert_equal "max-age=31536000", WebpackerUploader.config.cache_control
    assert_instance_of Logger, WebpackerUploader.config.logger
    refute WebpackerUploader.config.log_output
    refute WebpackerUploader.config.log_output?
    assert_equal "path/to/manifest.json", WebpackerUploader.config.public_manifest_path.to_s
    assert_equal "path/to/public/dir", WebpackerUploader.config.public_path.to_s

    assert_raises(NoMethodError) do
      WebpackerUploader.configure do |c|
        c.unknown = true
      end
    end
  end

  def test_pathname_casting
    WebpackerUploader.config do |c|
      c.public_manifest_path = "path/to/manifest.json"
      c.public_path = "path/to/public/dir"
    end

    assert_instance_of Pathname, WebpackerUploader.config.public_manifest_path
    assert_instance_of Pathname, WebpackerUploader.config.public_path

    WebpackerUploader.configure do |c|
      c.public_manifest_path = Pathname.new("path/to/manifest.json")
      c.public_path = Pathname.new("path/to/public/dir")
    end

    assert_instance_of Pathname, WebpackerUploader.config.public_manifest_path
    assert_instance_of Pathname, WebpackerUploader.config.public_path
  end
end
