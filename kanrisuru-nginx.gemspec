# frozen_string_literal: true

require File.expand_path('lib/kanrisuru/nginx/version', __dir__)

Gem::Specification.new do |gem|
  gem.name        = 'kanrisuru-nginx'
  gem.version     = Kanrisuru::Nginx::VERSION
  gem.author      = 'Ryan Mammina'
  gem.email       = 'ryan@avamia.com'
  gem.license     = 'MIT'
  gem.summary     = 'Manage nginx webservers with kanrisuru.'
  gem.description = 'Manage nginx webservers with kanrisuru.'
  gem.homepage    = 'https://github.com/avamia/kanrisuru-nginx'

  gem.required_ruby_version = ">= 2.5.0"

  gem.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  gem.executables   = gem.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency "kanrisuru", "~> 0.6"

  gem.add_development_dependency 'rspec', '~> 3.10'
  gem.add_development_dependency 'rubocop', '~> 1.12'
  gem.add_development_dependency 'rubocop-rspec', '~> 2.2'
  gem.add_development_dependency 'simplecov', '~> 0.21'

  gem.metadata = {
    'source_code_uri' => 'https://github.com/avamia/kanrisuru-nginx',
    'changelog_uri' => 'https://github.com/avamia/kanrisuru-nginx/blob/master/CHANGELOG.md',
    'homepage_uri' => gem.homepage
  }

end
