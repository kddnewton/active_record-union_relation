# frozen_string_literal: true

require_relative "lib/active_record/union_relation/version"

version = ActiveRecord::UnionRelation::VERSION
repository = "https://github.com/kddnewton/active_record-union_relation"

Gem::Specification.new do |spec|
  spec.name = "active_record-union_relation"
  spec.version = version
  spec.authors = ["Kevin Newton"]
  spec.email = ["kddnewton@gmail.com"]

  spec.summary = "Create ActiveRecord relations from UNIONs"
  spec.homepage = repository
  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "#{repository}/issues",
    "changelog_uri" => "#{repository}/blob/v#{version}/CHANGELOG.md",
    "source_code_uri" => repository,
    "rubygems_mfa_required" => "true"
  }

  spec.files = %w[
    CHANGELOG.md
    CODE_OF_CONDUCT.md
    LICENSE
    README.md
    active_record-union_relation.gemspec
    lib/active_record/union_relation.rb
    lib/active_record/union_relation/version.rb
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 6"

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "syntax_tree"
end
