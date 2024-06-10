# -*- encoding: utf-8 -*-
# stub: resolv-ipv6favor 0.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "resolv-ipv6favor".freeze
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ryosuke Yamazaki".freeze]
  s.date = "2010-04-21"
  s.description = "simple resolver class that lookup AAAA records prior to A records".freeze
  s.email = "ryosuke.yamazaki@mac.com".freeze
  s.extra_rdoc_files = ["LICENSE".freeze, "README.rdoc".freeze]
  s.files = ["LICENSE".freeze, "README.rdoc".freeze]
  s.homepage = "http://github.com/nappa/resolv-ipv6favor".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "simple resolver class that lookup AAAA records prior to A records".freeze

  s.installed_by_version = "3.1.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<shoulda>.freeze, [">= 0"])
  else
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
  end
end
