# frozen_string_literal: true

require_relative "lib/admin_tools/version"

Gem::Specification.new do |spec|
  spec.name = "admin_tools"
  spec.version = AdminTools::VERSION
  spec.authors = ["Jasper"]
  spec.email = ["your-email@example.com"]

  spec.summary = "Simple admin-only content helpers for Rails views"
  spec.description = "A lightweight Rails helper for conditionally rendering admin-only content in views. Wrap any content in an admin_tool block and it only renders for admin users."
  spec.homepage = "https://github.com/jasper/admin_tools"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.1"
end
