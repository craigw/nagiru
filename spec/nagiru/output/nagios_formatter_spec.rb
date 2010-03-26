require 'nagiru/output/nagios_formatter'
require 'nagiru/nagios/contact'

describe Nagiru::Output::NagiosFormatter do
  describe "formatting a contact" do
    before(:each) do
      @contact = Nagiru::Nagios::Contact.new(:email_address => "craig@barkingiguana.com", :name => "craig")
      @formatter = Nagiru::Output::NagiosFormatter.new
    end

    it "should output the email address" do
      output = @formatter.contact(@contact)
      # FIXME: This should have a custom rspec matcher for "match":
      #        output.should match(/email\s+craig@barkingiguana\.com/)
      if (output !~ /email\s+craig@barkingiguana\.com/)
        raise "Output should contain the email address"
      end
    end

    it "should output the contact name" do
      output = @formatter.contact(@contact)
      # FIXME: This should have a custom rspec matcher for "match":
      #        output.should match(/contact\_name\s+craig/)
      if (output !~ /contact\_name\s+craig/)
        raise "Output should contain the contact name"
      end
    end

    it "should output in a way that can be loaded back to a contact object" do
      output = Nagiru::Nagios::Contact.new(@formatter.contact(@contact))
      output.name.should eql(@contact.name)
      output.email_address.should eql(@contact.email_address)
    end
  end
end