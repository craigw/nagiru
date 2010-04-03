require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'cucumber'
require 'cucumber/rake/task'

coverage_data = "coverage.data"

Cucumber::Rake::Task.new(:features) do |t|
  t.libs = %W(lib)
  t.cucumber_opts = "features --format pretty"
  t.rcov = true
  t.rcov_opts =  %W(--exclude gems/,spec/,features/)
  t.rcov_opts += %W(--aggregate #{coverage_data})
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
  t.rcov_opts += %W(--aggregate #{coverage_data})
  t.rcov_opts += %W(-o coverage)
end

task :clear_coverage_data do
  File.unlink(coverage_data) if File.exists?(coverage_data)
end

RCov::VerifyTask.new(:verify_rcov => [ :clear_coverage_data, :spec, :features ]) do |t|
  t.threshold = 100.0
end

task :default => :verify_rcov