Gem::Specification.new do |s|
  s.name = "cbor-packed"
  s.version = "0.1.5"
  s.summary = "CBOR (Concise Binary Object Representation) packer"
  s.description = %q{cbor-packed implements packed encoding for CBOR, RFC 7049 Section 3.9}
  s.author = "Carsten Bormann"
  s.email = "cabo@tzi.org"
  s.license = "Apache-2.0"
  s.homepage = "http://cbor.io/"
  s.has_rdoc = false
  s.test_files = Dir['test/**/*.rb']
  s.files = Dir['lib/**/*.rb'] + %w(cbor-packed.gemspec) + Dir['bin/**/*.rb']
  s.executables = Dir['bin/**/*.rb'].map {|x| File.basename(x)}
  s.required_ruby_version = '>= 1.9.2'

  s.require_paths = ["lib"]
end
