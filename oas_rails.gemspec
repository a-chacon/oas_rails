require_relative 'lib/oas_rails/version'

Gem::Specification.new do |spec|
  spec.name = 'oas_rails'
  spec.version     = OasRails::VERSION
  spec.authors     = ['a-chacon']
  spec.email       = ['andres.ch@protonmail.com']
  spec.homepage    = 'https://github.com/a-chacon/oas_rails'
  spec.summary     = 'OasRails is a Rails engine for generating automatic interactive documentation for your Rails APIs. It generates an OAS document and displays it using a nice UI.'
  spec.description = <<HEREDOC
    # Open API Specification For Rails

    OasRails is a Rails engine for generating **automatic interactive documentation for your Rails APIs**. It generates an **OAS 3.1** document and displays it using **[RapiDoc](https://rapidocweb.com)**.

    ## What Sets OasRails Apart?

    - **Dynamic**: No command required to generate docs
    - **Simple**: Complement default documentation with a few comments; no need to learn a complex DSL
    - **Pure Ruby on Rails APIs**: No additional frameworks needed (e.g., Grape, RSpec)

HEREDOC
  spec.license = 'GPL-3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/a-chacon/oas_rails'
  spec.metadata['changelog_uri'] = 'https://github.com/a-chacon/oas_rails'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'esquema'
  spec.add_dependency 'method_source'
  spec.add_dependency 'rails', '>= 7.0.0'
  spec.add_dependency 'yard'
end
