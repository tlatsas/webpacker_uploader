# frozen_string_literal: true

require "aws-sdk-s3"

module WebpackerUploader
  module Providers
    class Aws
      attr_reader :client
      attr_reader :resource
      attr_reader :bucket

      def initialize(options)
        @client = ::Aws::S3::Client.new(credentials: credentials(options[:credentials]), region: options[:region])
        @resource = ::Aws::S3::Resource.new(client: @client)
        @bucket = @resource.bucket(options[:bucket])
      end

      def upload!(object_key, file, content_type = "")
        object = @bucket.object(object_key)
        object.upload_file(file, content_type: content_type)
      end

      private

        def credentials(options)
          if options[:profile_name].present?
            ::Aws::SharedCredentials.new(profile_name: options[:profile_name])
          elsif options.key?(:from_ec2) && options[:from_ec2]
            ::Aws::InstanceProfileCredentials.new
          else
            ::Aws::Credentials.new(options[:access_key_id], options[:secret_access_key])
          end
        end
    end
  end
end
