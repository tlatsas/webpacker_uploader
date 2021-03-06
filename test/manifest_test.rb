# frozen_string_literal: true

require "test_helper"

class ManifestTest < Minitest::Test
  def setup
    @manifest = ::WebpackerUploader::Manifest.new
  end

  def teardown
    WebpackerUploader.reset!
  end

  def test_assets
    assert_includes @manifest.assets, "application.css"
    assert_includes @manifest.assets, "application.js"
    assert_includes @manifest.assets, "application.png"
    refute_includes @manifest.assets, "entrypoints"
  end

  def test_missing_manifest
    WebpackerUploader.config.public_manifest_path = "missing.json"
    @empty_manifest = WebpackerUploader::Manifest.new

    assert_empty @empty_manifest.assets
  end
end
