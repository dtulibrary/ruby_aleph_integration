# encoding: UTF-8
require 'rake'
Gem::Specification.new do |spec|
  spec.name = 'ruby_aleph_integration'
  spec.version = '1.0.0'
  spec.authors = [ 'Morten Rønne' ]
  spec.add_runtime_dependency ('httparty')
  spec.add_runtime_dependency ('nokogiri')
  spec.add_development_dependency('rspec')
  spec.summary = 'Integration gem for ALEPH ILS'
  spec.description = <<-DESC
    This gem offers integration to ALEPH ILS from ExLibris.
DESC
  spec.files = FileList['lib/**/*.rb', 'app/**/*.rb', 'bin/*', '[A-Z]*',
    'spec/**/*'].to_a
  spec.has_rdoc = false
  spec.license = 'MIT'
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9.2'
  spec.requirements << 'Access to an ALEPH ILS'
end
