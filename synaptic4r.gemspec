# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{synaptic4r}
  s.version = "0.1.4"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["troystribling-att"]
  s.date = %q{2009-08-24}
  s.default_executable = %q{synrest}
  s.email = %q{troy.stribling@usi.com}
  s.executables = ["synrest"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/synrest",
     "lib/synaptic4r.rb",
     "lib/synaptic4r/client.rb",
     "lib/synaptic4r/help.rb",
     "lib/synaptic4r/request.rb",
     "lib/synaptic4r/rest.rb",
     "lib/synaptic4r/result.rb",
     "synaptic4r.gemspec"
  ]
  s.homepage = %q{http://github.com/troystribling-att/synaptic4r}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{CLI and Ruby REST Client for ATT Synaptic Storage}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0.8.3"])
      s.add_runtime_dependency(%q<rest-client>, [">= 1.0.2"])
    else
      s.add_dependency(%q<rake>, [">= 0.8.3"])
      s.add_dependency(%q<rest-client>, [">= 1.0.2"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0.8.3"])
    s.add_dependency(%q<rest-client>, [">= 1.0.2"])
  end
end
