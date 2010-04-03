Feature: List profiles
  In order to manage a new Nagios configurations
  As a system administrator
  I want to add a profile to Nagiru

Scenario: Create the first profile
  Given no profiles exist
  When I add a profile called "first-try"
  Then I should see "first-try" in the profile list