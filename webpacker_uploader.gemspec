require_relative "lib/webpacker_uploader/version"

Gem::Specification.new do |s|
  s.name          = "webpacker_uploader"
  s.version       = WebpackerUploader::VERSION
  s.authors       = ["Tasos Latsas"]
  s.email         = ["tlatsas@hey.com"]

  s.summary       = "Uploads manifest.json file contents to the cloud"
  s.description   = "Uploads manifest.json file contents to the cloud"
  s.homepage      = "https://github.com/tlatsas/webpacker_uploader"
  s.license       = "MIT"

  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  s.metadata = {
    "homepage_uri"    => s.homepage,
    "bug_tracker_uri" => "https://github.com/tlatsas/webpacker_uploader/issues",
    "changelog_uri"   => "https://github.com/tlatsas/webpacker_uploader/blob/main/CHANGELOG.md",
    "source_code_uri" => "https://github.com/tlatsas/webpacker_uploader/tree/v#{s.version}"
  }

  s.files         = `git ls-files`.split("\n").reject { |f| f.match(%r{^(bin|test|integration|.github)/}) }
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "webpacker", ">= 5.1"
  s.add_dependency "activesupport", "< 7.0"
  s.add_dependency "mime-types"
  s.add_dependency "rack", ">= 2", "< 4"

  s.add_development_dependency "bundler", ">= 1.3.0"
  s.add_development_dependency "rubocop", "1.11.0"
  s.add_development_dependency "rubocop-performance"
  s.add_development_dependency "rubocop-minitest"
end
