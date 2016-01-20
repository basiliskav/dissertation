# -*- encoding: utf-8 -*-
# stub: docx 0.2.07 ruby lib

Gem::Specification.new do |s|
  s.name = "docx"
  s.version = "0.2.07"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Christopher Hunt", "Marcus Ortiz", "Higgins Dragon", "Toms Mikoss", "Sebastian Wittenkamp"]
  s.date = "2014-10-29"
  s.description = "a ruby library/gem for interacting with .docx files"
  s.email = ["chrahunt@gmail.com"]
  s.homepage = "https://github.com/chrahunt/docx"
  s.rubygems_version = "2.4.8"
  s.summary = "a ruby library/gem for interacting with .docx files"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5"])
      s.add_runtime_dependency(%q<rubyzip>, ["~> 1.1.6"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<nokogiri>, ["~> 1.5"])
      s.add_dependency(%q<rubyzip>, ["~> 1.1.6"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["~> 1.5"])
    s.add_dependency(%q<rubyzip>, ["~> 1.1.6"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
