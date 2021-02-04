# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @instance = WebpackerUploader::Instance.new
    WebpackerUploader.instance = @instance
  end

  def test_ignored_extensions
    assert_equal WebpackerUploader.ignored_extensions, [".map"]

    @instance.ignored_extensions = [".css", ".js"]
    assert_equal WebpackerUploader.ignored_extensions, [".css", ".js"]
  end
end
