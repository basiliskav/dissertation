# -*- encoding: utf-8 -*-
# stub: wysiwyg-rails 1.2.8 ruby lib

Gem::Specification.new do |s|
  s.name = "wysiwyg-rails"
  s.version = "1.2.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Froala Labs"]
  s.date = "2015-07-12"
  s.description = "A beautiful jQuery WYSIWYG HTML text editor. High performance and modern design make it easy to use for developers and loved by users."
  s.email = ["stefan@froala.com"]
  s.homepage = "https://github.com/froala/wysiwyg-rails"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.8"
  s.summary = "an asset gemification of the Froala WYSIWYG Editor library"

  s.installed_by_version = "2.4.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<railties>, ["< 5.0", ">= 3.2"])
      s.add_runtime_dependency(%q<font-awesome-rails>, [">= 4.3.0.0"])
    else
      s.add_dependency(%q<railties>, ["< 5.0", ">= 3.2"])
      s.add_dependency(%q<font-awesome-rails>, [">= 4.3.0.0"])
    end
  else
    s.add_dependency(%q<railties>, ["< 5.0", ">= 3.2"])
    s.add_dependency(%q<font-awesome-rails>, [">= 4.3.0.0"])
  end
end
