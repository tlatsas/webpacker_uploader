# frozen_string_literal: true

require "minitest/autorun"
require "aws-sdk-s3"
require_relative "dummy/config/environment"

def localstack_client
  Aws::S3::Client.new(
    credentials: Aws::Credentials.new("test", "test"),
    region: "us-east-1",
    endpoint: "http://localhost:4566",
    force_path_style: true
  )
end
