# frozen_string_literal: true

require "test_helper"

class ManifestTest < Minitest::Test
  def setup
    @manifest = ::WebpackerUploader::Manifest.new
  end

  def test_assets
    assert_includes @manifest.assets, "application.css"
    assert_includes @manifest.assets, "application.js"
    assert_includes @manifest.assets, "application.png"
    refute_includes @manifest.assets, "entrypoints"
  end
end
