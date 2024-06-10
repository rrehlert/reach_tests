# -*- encoding: utf-8 -*-
# stub: cbor 0.5.9.6 ruby lib
# stub: ext/cbor/extconf.rb

Gem::Specification.new do |s|
  s.name = "cbor".freeze
  s.version = "0.5.9.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Carsten Bormann, standing on the tall shoulders of Sadayuki Furuhashi".freeze]
  s.date = "2019-06-22"
  s.description = "CBOR is a library for the CBOR binary object representation format, based on Sadayuki Furuhashi's MessagePack library.".freeze
  s.email = "cabo@tzi.org".freeze
  s.extensions = ["ext/cbor/extconf.rb".freeze]
  s.files = ["ext/cbor/extconf.rb".freeze]
  s.homepage = "http://cbor.io/".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "CBOR, Concise Binary Object Representation.".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 0.9.2"])
    s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 0.8.3"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 2.11"])
    s.add_development_dependency(%q<json>.freeze, ["~> 1.7"])
    s.add_development_dependency(%q<yard>.freeze, ["~> 0.9.11"])
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 0.9.2"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 0.8.3"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.11"])
    s.add_dependency(%q<json>.freeze, ["~> 1.7"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9.11"])
  end
end
