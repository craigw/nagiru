require 'nagiru/output/nagios_formatter'
require 'nagiru/nagios/contact'
require 'stringio'

describe Nagiru::Output::NagiosFormatter do
  describe "formatting a contact" do
    before(:each) do
      @contact = Nagiru::Nagios::Contact.new(:email_address => "craig@barkingiguana.com", :name => "craig")
      @formatter = Nagiru::Output::NagiosFormatter.new(String.new)
    end

    it "should output 'define contact {' at the start" do
      @formatter.contact(@contact)
      # FIXME: This should have a custom rspec matcher for "match":
      #        first_line.should match(/^define\s+contact\s+\{/)
      first_line = @formatter.output.strip.split(/\n/)[0]
      if (first_line !~ /^\s*define\s+contact\s*\{\s*$/)
        raise "Output should start with 'define contact {'"
      end
    end

    it "should output '}' at the end" do
      @formatter.contact(@contact)
      # FIXME: This should have a custom rspec matcher for "match":
      #        last_line.should match(/^\s*\}\s*$/)
      last_line = @formatter.output.strip.split(/\n/)[-1]
      if (last_line !~ /^\s*\}\s*$/)
        raise "Output should end with '}'"
      end
    end

    it "should output the email address" do
      @formatter.contact(@contact)
      # FIXME: This should have a custom rspec matcher for "match":
      #        output.should match(/email\s+craig@barkingiguana\.com/)
      if (@formatter.output !~ /email\s+craig@barkingiguana\.com/)
        raise "Output should contain the email address"
      end
    end

    it "should output the contact name" do
      @formatter.contact(@contact)
      # FIXME: This should have a custom rspec matcher for "match":
      #        output.should match(/contact\_name\s+craig/)
      if (@formatter.output !~ /contact\_name\s+craig/)
        raise "Output should contain the contact name"
      end
    end

    it "should output in a format that can be parsed back into a contact object" do
      @formatter.contact(@contact)
      contacts = Nagiru::Nagios::Contact.parse(@formatter.output)
      contacts[0].name.should eql(@contact.name)
      contacts[0].email_address.should eql(@contact.email_address)
    end
  end
end