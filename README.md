# WebpackerUploader

Webpacker uploader provides an easy way to upload your assets to AWS S3.
It knows which files to upload by reading the `manifest.json` file.

This is particularly useful if you serve your application's assets through a combination of
S3 + CDN, outside of your Rails application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "webpacker_uploader"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install webpacker_uploader

To use the aws provider install the aws-sdk-s3 gem. Add in your Gemfile:

```ruby
gem "aws-sdk-s3", require: false
```

## Usage

```ruby
    require 'webpacker_uploader'
    require 'webpacker_uploader/providers/aws'

    provider_options = {
      credentials: { profile_name: "staging" },
      region: "eu-central-1",
      bucket: "application-assets-20200929124523451600000001"
    }

    provider = WebpackerUploader::Providers::Aws.new(provider_options)
    WebpackerUploader.upload!(provider)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tlatsas/webpacker_uploader.

See [CONTRIBUTING](CONTRIBUTING.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
