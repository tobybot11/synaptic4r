require 'rubygems'
require 'rake'

#####-------------------------------------------------------------------------------------------------------
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "synaptic4r"
    gem.summary = "CLI and Ruby REST Client for ATT Synaptic Storage"
    gem.email = "troy.stribling@usi.com"
    gem.homepage = "http://github.com/attsynaptic/synaptic4r"
    gem.authors = ["troystribling-att"]
    gem.add_dependency('rest-client', '>= 1.0.2')
  end

  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

task :default => :test

#####-------------------------------------------------------------------------------------------------------
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

#####-------------------------------------------------------------------------------------------------------
begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

#####-------------------------------------------------------------------------------------------------------
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "synaptic4r #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

