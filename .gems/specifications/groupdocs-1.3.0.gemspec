# -*- encoding: utf-8 -*-
# stub: groupdocs 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "groupdocs"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Alex Rodionov"]
  s.date = "2013-02-27"
  s.description = "Ruby SDK for GroupDocs REST API"
  s.email = "p0deje@gmail.com"
  s.homepage = "https://github.com/groupdocs/groupdocs-ruby"
  s.rubygems_version = "2.4.8"
  s.summary = "Ruby SDK for GroupDocs REST API"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6"])
      s.add_runtime_dependency(%q<json>, ["~> 1.7"])
      s.add_runtime_dependency(%q<mime-types>, ["~> 1.19"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12"])
      s.add_development_dependency(%q<fuubar>, ["~> 1.1"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<yard>, ["~> 0.8"])
      s.add_development_dependency(%q<webmock>, ["~> 1.9"])
    else
      s.add_dependency(%q<rest-client>, ["~> 1.6"])
      s.add_dependency(%q<json>, ["~> 1.7"])
      s.add_dependency(%q<mime-types>, ["~> 1.19"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.12"])
      s.add_dependency(%q<fuubar>, ["~> 1.1"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<yard>, ["~> 0.8"])
      s.add_dependency(%q<webmock>, ["~> 1.9"])
    end
  else
    s.add_dependency(%q<rest-client>, ["~> 1.6"])
    s.add_dependency(%q<json>, ["~> 1.7"])
    s.add_dependency(%q<mime-types>, ["~> 1.19"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.12"])
    s.add_dependency(%q<fuubar>, ["~> 1.1"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<yard>, ["~> 0.8"])
    s.add_dependency(%q<webmock>, ["~> 1.9"])
  end
end
