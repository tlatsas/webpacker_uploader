require "webpacker_uploader"
require "webpacker_uploader/providers/aws"

namespace :assets do
  task :upload do
    WebpackerUploader.config.ignored_extensions = [".map"]

    provider_options = {
      credentials: { access_key_id: "test", secret_access_key: "test" },
      region: "us-east-1",
      bucket: "assets",
      endpoint: "http://localhost:4566",
      force_path_style: true
    }

    provider = WebpackerUploader::Providers::Aws.new(provider_options)
    WebpackerUploader.upload!(provider)
  end
end
