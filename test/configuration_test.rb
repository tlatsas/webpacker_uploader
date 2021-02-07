# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < WebpackerUploader::Test
  def test_ignored_extensions
    assert_equal WebpackerUploader.ignored_extensions, [".map"]

    with_ignored_extensions_config([".css", ".js"]) do
      assert_equal WebpackerUploader.ignored_extensions, [".css", ".js"]
    end
  end
end
