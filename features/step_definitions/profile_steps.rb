Given /^no profiles exist$/ do
  profiles = nagiru.profile.list.execute
  profiles.split(/\n/).each do |profile|
    nagiru.profile.remove(profile).execute
  end
end

Given /^a profile called "([^\"]*)" exists$/ do |profile_name|
  Given("no profiles exist")
  nagiru.profile.create(profile_name).execute
end

When /^I add a profile called "([^\"]*)"$/ do |profile_name|
  nagiru.profile.create(profile_name).execute
end

When /^I import the (.*) profile as "([^\"]*)"$/ do |config, name|
  config_dir = File.join(File.dirname(__FILE__), '..', 'support', 'fixtures')
  profile = name.split(/,/).map{|s|s.strip}.sort.join('_')
  profile = File.expand_path(File.join(config_dir, profile, 'nagios.cfg'))
  command = nagiru.profile.import(:source => "file://#{profile}")
  command.execute
end

When /^I remove the profile "([^\"]*)"$/ do |profile_name|
  nagiru.profile.remove(profile_name).execute
end

Then /^I should see "([^\"]*)" in the profile list$/ do |name|
  nagiru.profile.list.execute
  profiles = nagiru.output.split(/\n/)
  profiles.should include(name)
end

Then /^I should see no profiles in the profile list$/ do
  nagiru.profile.list.execute
  profiles = nagiru.output.split(/\n/)
  profiles.should have(0).profiles
end
