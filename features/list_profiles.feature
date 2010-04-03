Feature: List profiles
  In order to see which profiles Nagiru is currently managing
  As a system administrator
  I want to list all profiles managed by Nagiru

Scenario: One profile exists
  Given a profile called "example-profile" exists
  Then I should see "example-profile" in the profile list