require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
  t.rcov = true
  t.rcov_opts =  %W(--exclude gems/,spec/,features/)
  t.rcov_opts += %W(--aggregate coverage.data)
  t.rcov_opts += %W(-o coverage)
end

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
  t.rcov_opts =  %W(--exclude gems/,spec/,features/ )
  t.rcov_opts += %W(--aggregate coverage.data)
  t.rcov_opts += %W(-o coverage)
end

RCov::VerifyTask.new(:verify_rcov => [ :spec, :features ]) do |t|
  t.threshold = 100.0
end

task :default => :verify_rcov