# frozen_string_literal: true

require_relative 'lib/active_record/union_relation/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_record-union_relation'
  spec.version       = ActiveRecord::UnionRelation::VERSION
  spec.authors       = ['Kevin Deisz']
  spec.email         = ['kevin.deisz@gmail.com']

  spec.summary       = 'Create ActiveRecord relations from UNIONs'
  spec.homepage      = 'https://github.com/kddeisz/active_record-union_relation'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 6'

  spec.add_development_dependency 'minitest', '~> 5.14'
  spec.add_development_dependency 'pg', '~> 1.2'
  spec.add_development_dependency 'rails', '~> 6.1'
  spec.add_development_dependency 'rake', '~> 13.0'
end
