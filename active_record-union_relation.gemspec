# frozen_string_literal: true

require_relative 'lib/active_record/union_relation/version'

version = ActiveRecord::UnionRelation::VERSION
repository = 'https://github.com/kddnewton/active_record-union_relation'

Gem::Specification.new do |spec|
  spec.name          = 'active_record-union_relation'
  spec.version       = version
  spec.authors       = ['Kevin Newton']
  spec.email         = ['kddnewton@gmail.com']

  spec.summary       = 'Create ActiveRecord relations from UNIONs'
  spec.homepage      = repository
  spec.license       = 'MIT'

  spec.metadata      = {
    'bug_tracker_uri' => "#{repository}/issues",
    'changelog_uri' => "#{repository}/blob/v#{version}/CHANGELOG.md",
    'source_code_uri' => repository,
    'rubygems_mfa_required' => 'true'
  }

  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 6'

  spec.add_development_dependency 'minitest', '~> 5.15'
  spec.add_development_dependency 'pg', '~> 1.2'
  spec.add_development_dependency 'rails', '~> 7.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
