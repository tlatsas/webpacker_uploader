# frozen_string_literal: true

require "aws-sdk-s3"

module WebpackerUploader
  # Namespace for the upload providers.
  module Providers
    # AWS provider uploads files to AWS S3. It uses the +aws-sdk-s3+ gem.
    class Aws
      # AWS provider error class. Raised when the provided AWS client credentials options are wrong.
      class CredentialsError < StandardError; end

      # @param [Hash] options
      #   * :region (String) The S3 region name.
      #   * :bucket (String) The S3 bucket name.
      #   * :credentials (Hash) credential options for the AWS provider:
      #     * :profile_name (String) use a named profile configured in ~/.aws/credentials
      #     * :instance_profile (Boolean) use an instance profile from an EC2
      #     * :access_key_id (String) the AWS credentials access id.
      #     * :secret_access_key (String) the AWS credentials secret access key.
      #
      # @note Any unknown options will be passed directly to the +Aws::S3::Client+ class
      #   during initialization.
      #
      # @raise [CredentialsError] if the credential options Hash is not correct.
      #
      # @example Initialize using a named profile:
      #
      #   provider_options = {
      #     credentials: { profile_name: "staging" },
      #     region: "eu-central-1",
      #     bucket: "application-assets-20200929124523451600000001"
      #   }
      #   provider = WebpackerUploader::Providers::Aws.new(provider_options)
      #
      # @example Initialize using IAM keys
      #
      #   provider_options = {
      #     credentials: { access_key_id: "KEY_ID", secret_access_key: "ACCESS_KEY" },
      #     region: "eu-central-1",
      #     bucket: "application-assets-20200929124523451600000001"
      #   }
      #   provider = WebpackerUploader::Providers::Aws.new(provider_options)
      #
      # @example Initialize using an EC2 instance profile
      #
      #   provider_options = {
      #     credentials: { instance_profile: true },
      #     region: "eu-central-1",
      #     bucket: "application-assets-20200929124523451600000001"
      #   }
      #   provider = WebpackerUploader::Providers::Aws.new(provider_options)
      def initialize(options)
        @region      = options.delete(:region)
        @bucket_name = options.delete(:bucket)
        @credentials = credentials(options.delete(:credentials))
        @aws_options = options
        @resource    = ::Aws::S3::Resource.new(client: client)
      end

      # Uploads a file to AWS S3.
      #
      # @param object_key [String] Is the remote path name for the S3 object.
      # @param file [Pathname] Path of the local file.
      # @param content_type [String] The content type that will be set to the S3 object.
      # @return [void]
      def upload!(object_key, file, content_type = "", cache_control = "")
        object = @resource.bucket(@bucket_name).object(object_key)
        object.upload_file(file, content_type: content_type, cache_control: cache_control)
      end

      private
        def credentials(options)
          if options.key?(:profile_name)
            { profile: options[:profile_name] }
          elsif options.key?(:instance_profile) && options[:instance_profile]
            ::Aws::InstanceProfileCredentials.new
          elsif options.key?(:access_key_id) && options.key?(:secret_access_key)
            ::Aws::Credentials.new(options[:access_key_id], options[:secret_access_key])
          else
            raise CredentialsError, "Wrong AWS provider credentials options."
          end
        end

        def profile?
          @credentials.is_a?(Hash) && @credentials.key?(:profile)
        end

        def credentials_object?
          !profile?
        end

        def client
          ::Aws::S3::Client.new(client_options)
        end

        def client_options
          opts = {}
          opts.merge!(@aws_options)
          opts[:region] = @region
          opts.merge!(@credentials) if profile?
          opts[:credentials] = @credentials if credentials_object?
          opts
        end
    end
  end
end
