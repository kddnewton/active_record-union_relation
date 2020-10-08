# frozen_string_literal: true

require_relative 'lib/active_record/union/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_record-union'
  spec.version       = ActiveRecord::Union::VERSION
  spec.authors       = ['Kevin Deisz']
  spec.email         = ['kevin.deisz@gmail.com']

  spec.summary       = 'Create ActiveRecord relations from UNIONs'
  spec.homepage      = 'https://github.com/kddeisz/active_record-union'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rake'
end
