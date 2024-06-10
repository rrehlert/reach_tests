Gem::Specification.new do |s|
  s.name = "cbor-deterministic"
  s.version = "0.1.3"
  s.summary = "CBOR (Concise Binary Object Representation) deterministic encoding"
  s.description = %q{cbor-deterministic implements deterministic encoding for CBOR, RFC 8949 Section 4.2}
  s.author = "Carsten Bormann"
  s.email = "cabo@tzi.org"
  s.license = "Apache-2.0"
  s.homepage = "http://cbor.io/"
  s.has_rdoc = false
  s.test_files = Dir['test/**/*.rb']
  s.files = Dir['lib/**/*.rb'] + %w(cbor-deterministic.gemspec) + Dir['bin/**/*.rb']
  s.executables = Dir['bin/**/*.rb'].map {|x| File.basename(x)}
  s.required_ruby_version = '>= 1.9.2'

  s.require_paths = ["lib"]
end
