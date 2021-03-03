# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- Allow gem configuration. ([@tlatsas](https://github.com/tlatsas))

### Changed

- With the newly introduced configuration options, ignored file extension list is now empty by default.
  This means that every file type will be uploaded unless otherwise specified. ([@tlatsas](https://github.com/tlatsas))

## [[0.2.1]](https://github.com/tlatsas/webpacker_uploader/releases/tag/v0.2.1) - 2021-02-09

### Added

- Make file exclusion list configurable. ([#3](https://github.com/tlatsas/webpacker_uploader/pull/3), [@estebanz01](https://github.com/estebanz01))
- Support prefixing remote S3 paths. ([#2](https://github.com/tlatsas/webpacker_uploader/pull/2), [@estebanz01](https://github.com/estebanz01))
- AWS provider: Add support for EC2 instance profile credentials. ([#2](https://github.com/tlatsas/webpacker_uploader/pull/2), [@estebanz01](https://github.com/estebanz01))

## [[0.1.0]](https://github.com/tlatsas/webpacker_uploader/releases/tag/v0.1.0) - 2020-10-01

### Added

- Initial release. ([@tlatsas](https://github.com/tlatsas))
