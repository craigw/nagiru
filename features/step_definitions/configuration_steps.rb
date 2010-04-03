Given /^I have a (.*) configuration$/ do |parameters|
  configuration = parameters.split(/,/).map{|s|s.strip}.sort.join('_')
  support_directory = File.join(File.dirname(__FILE__), '..', 'support')
  configuration_directory = File.join(support_directory, 'fixtures')
  configuration_instance = File.join(configuration_directory, configuration)
  configuration_file = File.join(configuration_instance, 'nagios.cfg')
  File.should exist(configuration_file)
end