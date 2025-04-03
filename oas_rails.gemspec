require_relative 'lib/oas_rails/version'

Gem::Specification.new do |spec|
  spec.name = 'oas_rails'
  spec.version     = OasRails::VERSION
  spec.authors     = ['a-chacon']
  spec.email       = ['andres.ch@protonmail.com']
  spec.homepage    = 'https://github.com/a-chacon/oas_rails'
  spec.summary     = 'OasRails is a Rails engine for generating automatic interactive documentation for your Rails APIs.'
  spec.description =
    'OasRails is a Rails engine for generating automatic interactive documentation for your Rails APIs. It generates an OAS 3.1 document and displays it using RapiDoc.'

  spec.license = 'GPL-3.0-only'

  spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata['source_code_uri'] = 'https://github.com/a-chacon/oas_rails'
  # spec.metadata['changelog_uri'] = 'https://github.com/a-chacon/oas_rails'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib,public}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  end

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency 'easy_talk', '~> 1.0'
  spec.add_dependency 'method_source', '~> 1.0'
  spec.add_dependency 'yard', '~> 0.9'
end
