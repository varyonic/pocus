$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'pocus/identity'

Gem::Specification.new do |spec|
  spec.name = Pocus::Identity.name
  spec.version = Pocus::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = ['Piers Chambers']
  spec.email = ['piers@varyonic.com']
  spec.homepage = 'https://github.com//pocus'
  spec.summary = ''
  spec.description = ''
  spec.license = 'MIT'

  if ENV['RUBY_GEM_SECURITY'] == 'enabled'
    spec.signing_key = File.expand_path('~/.ssh/gem-private.pem')
    spec.cert_chain = [File.expand_path('~/.ssh/gem-public.pem')]
  end

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'gemsmith', '~> 7.7'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'pry-state'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 0.40'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.files = Dir['lib/**/*', 'vendor/**/*']
  spec.extra_rdoc_files = Dir['README*', 'LICENSE*']
  spec.require_paths = ['lib']
end
