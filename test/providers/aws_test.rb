# frozen_string_literal: true

require "test_helper"
require "webpacker_uploader/providers/aws"

class AwsTest < Minitest::Test
  def test_credentials_initialization
    assert_raises(WebpackerUploader::Providers::Aws::CredentialsError) do
      WebpackerUploader::Providers::Aws.new(credentials: {})
    end

    assert_raises(WebpackerUploader::Providers::Aws::CredentialsError) do
      WebpackerUploader::Providers::Aws.new(credentials: { access_key_id: "test" })
    end
  end
end
