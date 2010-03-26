require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

Spec::Rake::SpecTask.new do |t|
  t.ruby_opts = [ '-I lib' ]
  t.spec_opts = [
    "--colour",
    "--format", "progress",
    "--loadby", "mtime",
    "--reverse",
    "--format", "html:coverage/index.html"
  ]
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = [ '--exclude', 'lib/spec,bin/spec,spec/,gems' ]
end

RCov::VerifyTask.new(:verify_rcov => :spec) do |t|
  t.threshold = 100.0
end

task :default => :spec