# WebpackerUploader

[![Ruby tests](https://img.shields.io/github/workflow/status/tlatsas/webpacker_uploader/Ruby%20tests?style=flat-square)](https://github.com/tlatsas/webpacker_uploader/actions)
[![RuboCop](https://img.shields.io/github/workflow/status/tlatsas/webpacker_uploader/RuboCop?label=rubocop&style=flat-square)](https://github.com/tlatsas/webpacker_uploader/actions)
[![Gem](https://img.shields.io/gem/v/webpacker_uploader?style=flat-square)](https://rubygems.org/gems/webpacker_uploader)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg?style=flat-square)](https://www.rubydoc.info/gems/webpacker_uploader)

Webpacker uploader provides an easy way to upload your assets to AWS S3.
It knows which files to upload by reading the `manifest.json` file.

This is particularly useful if you serve your application's assets through a combination of
S3 + CDN, outside of your Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "webpacker_uploader", require: false
```

and run:

    $ bundle install

or:

    $ gem install webpacker_uploader

To use the aws provider install the aws-sdk-s3 gem. Add in your Gemfile:

```ruby
gem "aws-sdk-s3", require: false
```

## Usage

Usually, in a Rake task you would add the following to upload the assets to AWS S3:

```ruby
require "webpacker_uploader"
require "webpacker_uploader/providers/aws"

provider_options = {
  credentials: { profile_name: "staging" },
  region: "eu-central-1",
  bucket: "application-assets-20200929124523451600000001"
}

provider = WebpackerUploader::Providers::Aws.new(provider_options)
WebpackerUploader.upload!(provider)
```

Currently, the only provider implemented is the AWS S3 provider.

### AWS S3 provider

The AWS S3 provider credentials can be configured in three ways.
Passing a named profile name:

```ruby
provider_options = {
  credentials: { profile_name: "staging" },
  region: "eu-central-1",
  bucket: "application-assets-20200929124523451600000001"
}

provider = WebpackerUploader::Providers::Aws.new(provider_options)
```

passing the access and the secret keys directly:

```ruby
provider_options = {
  credentials: { access_key_id: "AKIAIOSFODNN7EXAMPLE", secret_access_key: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYzEXAMPLEKEY" },
  region: "eu-central-1",
  bucket: "application-assets-20200929124523451600000001"
}

provider = WebpackerUploader::Providers::Aws.new(provider_options)
```

or using an EC2 instance profile:

```ruby
provider_options = {
  credentials: { instance_profile: true },
  region: "eu-central-1",
  bucket: "application-assets-20200929124523451600000001"
}

provider = WebpackerUploader::Providers::Aws.new(provider_options)
```

### Prefix remote files

Uploaded files can be prefixed by setting the `prefix` parameter during upload:

```ruby
WebpackerUploader.upload!(provider, prefix: "assets")
```

This will prefix all remote file paths with `assets` so instead of storing `packs/application-dd6b1cd38bfa093df600.css` it
will store `assets/packs/application-dd6b1cd38bfa093df600.css`.

### Configuration

WebpackerUploader currently supports the following configuration options:

| option               | description                                                  | default value                         |
|----------------------|--------------------------------------------------------------|---------------------------------------|
| ignored_extensions   | Which files uploader should skip based on the file extension | []                                    |
| logger               | The logger to use for logging                                | ActiveSupport::Logger.new(STDOUT)     |
| log_output           | Log output as we upload files                                | true                                  |
| public_manifest_path | The webpack manifest path                                    | Webpacker.config.public_manifest_path |
| public_path          | The webpack public output path                               | Webpacker.config.public_path          |

It can be configured using a block:

```ruby
WebpackerUploader.configure do |config|
  config.ignored_extensions = [".png", ".jpg", ".webp"]
  config.log_output = false
  config.public_manifest_path = "path/to/manifest.json"
  config.public_path = "path/to/public/dir"
end
```

or directly:

```ruby
WebpackerUploader.config.log_output = false
```

The uploader used to skip `.map` files by default. This has changed (see [CHANGELOG.md](https://github.com/tlatsas/webpacker_uploader/blob/main/CHANGELOG.md))
and everything is uploaded by default now. To retain the previous functionality use:

```ruby
# skip uploading map files
WebpackerUploader.config.ignored_extensions = [".map"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Integration tests

This gem also provides an integration test suite. It runs using [localstack](https://github.com/localstack/localstack/).
To run the integration tests, install docker on your system and spin up a localstack container running the s3 service.

```shell
docker compose -f "integration/docker-compose.yml" up --detach
```

To run the tests, use `rake test:integration`.

To stop the container once done run: `docker-compose -f "integration/docker-compose.yml" down` 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tlatsas/webpacker_uploader.

See [CONTRIBUTING](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
