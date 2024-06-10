# -*- encoding: utf-8 -*-
# stub: cbor-diag 0.7.6 ruby lib

Gem::Specification.new do |s|
  s.name = "cbor-diag".freeze
  s.version = "0.7.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Carsten Bormann".freeze]
  s.date = "2022-02-23"
  s.description = "cbor-diag implements diagnostic notation for CBOR, RFC 8949 and RFC 8742".freeze
  s.email = "cabo@tzi.org".freeze
  s.executables = ["cbor2diag.rb".freeze, "cbor2json.rb".freeze, "cbor2pretty.rb".freeze, "cbor2u8.rb".freeze, "cbor2yaml.rb".freeze, "cborleader2diag.rb".freeze, "cborseq2diag.rb".freeze, "cborseq2json.rb".freeze, "cborseq2neatjson.rb".freeze, "cborseq2pretty.rb".freeze, "cborseq2yaml.rb".freeze, "diag2cbor.rb".freeze, "diag2diag.rb".freeze, "diag2pretty.rb".freeze, "json2cbor.rb".freeze, "json2json.rb".freeze, "json2neatjson.rb".freeze, "json2pretty.rb".freeze, "json2yaml.rb".freeze, "pretty2cbor.rb".freeze, "pretty2diag.rb".freeze, "yaml2cbor.rb".freeze, "yaml2json.rb".freeze]
  s.files = ["bin/cbor2diag.rb".freeze, "bin/cbor2json.rb".freeze, "bin/cbor2pretty.rb".freeze, "bin/cbor2u8.rb".freeze, "bin/cbor2yaml.rb".freeze, "bin/cborleader2diag.rb".freeze, "bin/cborseq2diag.rb".freeze, "bin/cborseq2json.rb".freeze, "bin/cborseq2neatjson.rb".freeze, "bin/cborseq2pretty.rb".freeze, "bin/cborseq2yaml.rb".freeze, "bin/diag2cbor.rb".freeze, "bin/diag2diag.rb".freeze, "bin/diag2pretty.rb".freeze, "bin/json2cbor.rb".freeze, "bin/json2json.rb".freeze, "bin/json2neatjson.rb".freeze, "bin/json2pretty.rb".freeze, "bin/json2yaml.rb".freeze, "bin/pretty2cbor.rb".freeze, "bin/pretty2diag.rb".freeze, "bin/yaml2cbor.rb".freeze, "bin/yaml2json.rb".freeze]
  s.homepage = "http://cbor.io/".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2".freeze)
  s.rubygems_version = "3.1.6".freeze
  s.summary = "CBOR (Concise Binary Object Representation) diagnostic notation".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1"])
    s.add_runtime_dependency(%q<treetop>.freeze, ["~> 1"])
    s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<neatjson>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<cbor-deterministic>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<cbor-canonical>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<cbor-packed>.freeze, [">= 0"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1"])
    s.add_dependency(%q<treetop>.freeze, ["~> 1"])
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<neatjson>.freeze, [">= 0"])
    s.add_dependency(%q<cbor-deterministic>.freeze, [">= 0"])
    s.add_dependency(%q<cbor-canonical>.freeze, [">= 0"])
    s.add_dependency(%q<cbor-packed>.freeze, [">= 0"])
  end
end
