# frozen_string_literal: true

require_relative "lib/frontgo/version"

Gem::Specification.new do |spec|
  spec.name = "frontgo"
  spec.version = Frontgo::VERSION
  spec.authors = ["Stanislav (Stas) Katkov"]
  spec.email = ["contact@skatkov.com"]

  spec.summary = "Ruby client for FrontPayment API"
  spec.description = "A Ruby wrapper for the FrontPayment API supporting orders, customers, subscriptions, refunds, and terminal operations."
  spec.homepage = "https://github.com/skatkov/frontgo"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/skatkov/frontgo"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
end
