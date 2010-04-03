Feature: Remove profile
  In order to remove an unused profile from Nagiru
  As a system administrator
  I want to tell Nagiru to remove a profile

Scenario: Profile to remove exists
  Given a profile called "example-profile" exists
  When I remove the profile "example-profile"
  Then I should see no profiles in the profile list