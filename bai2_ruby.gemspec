# frozen_string_literal: true

require_relative "lib/bai2_ruby/version"

Gem::Specification.new do |spec|
  spec.name = "bai2_ruby"
  spec.version = BAI2::VERSION
  spec.authors = ["dpaluy"]
  spec.email = ["dpaluy@users.noreply.github.com"]

  spec.summary = "BAI2 implementation wrapper for Ruby"
  spec.description = "Bank Administration Institute 2 (BAI2) file format implementation wrapper for Ruby"
  spec.homepage = "https://github.com/dpaluy/bai2_ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

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
end
