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

  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  s.metadata = {
    "homepage_uri"    => s.homepage,
    "bug_tracker_uri" => "https://github.com/tlatsas/webpacker_uploader/issues",
    "changelog_uri"   => "https://github.com/tlatsas/webpacker_uploader/blob/main/CHANGELOG.md",
    "source_code_uri" => "https://github.com/tlatsas/webpacker_uploader/tree/v#{s.version}"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "webpacker", ">= 5.1"
  s.add_dependency "mime-types"

  s.add_development_dependency "bundler", ">= 1.3.0"
  s.add_development_dependency "rubocop", "< 0.69"
  s.add_development_dependency "rubocop-performance"
end
