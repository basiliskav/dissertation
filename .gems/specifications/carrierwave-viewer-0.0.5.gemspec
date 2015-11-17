# -*- encoding: utf-8 -*-
# stub: carrierwave-viewer 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "carrierwave-viewer"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["GarPit"]
  s.date = "2013-03-26"
  s.description = "Carrierwave integration with GroupDocs service"
  s.email = ["garik.piton@gmail.com"]
  s.homepage = ""
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "Carrierwave integration with GroupDocs service"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<carrierwave>, [">= 0.6.2"])
      s.add_runtime_dependency(%q<groupdocs>, ["~> 1.3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<carrierwave>, [">= 0.6.2"])
      s.add_dependency(%q<groupdocs>, ["~> 1.3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<carrierwave>, [">= 0.6.2"])
    s.add_dependency(%q<groupdocs>, ["~> 1.3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
