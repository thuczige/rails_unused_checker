# frozen_string_literal: true

require_relative "lib/rails_unused_checker/version"

Gem::Specification.new do |spec|
  spec.name = "rails_unused_checker"
  spec.version = RailsUnusedChecker::VERSION
  spec.authors = ["thuczige"]
  spec.email = ["thucpt@zigexn.vn"]

  spec.summary = "A gem to identify unused routes, controllers, actions, views, and partials in Rails projects."
  spec.description = "rails_unused_checker helps you clean up your Rails project by identifying unused routes, controllers, actions, views, and partials."
  spec.homepage = "https://github.com/thuczige/rails_unused_checker"
  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/thuczige/rails_unused_checker"
  spec.metadata["changelog_uri"] = "https://github.com/thuczige/rails_unused_checker/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
