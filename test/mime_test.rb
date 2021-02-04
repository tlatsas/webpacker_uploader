# frozen_string_literal: true

require "test_helper"

class MimeTest < Minitest::Test
  def test_for_webp
    # Rack < 3.x does not support this so we have a fallback mechanism in place
    assert_equal "image/webp", WebpackerUploader::Mime.mime_type("image-dd6b1cd38bfa093df600.webp")
  end

  def test_for_sourcemap
    assert_equal "application/octet-stream", WebpackerUploader::Mime.mime_type("application-dd6b1cd38bfa093df600.css.map")
  end
end
