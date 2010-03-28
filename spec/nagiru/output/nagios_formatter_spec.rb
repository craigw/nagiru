require 'nagiru/output/nagios_formatter'
require 'nagiru/nagios/contact'
require 'stringio'

describe Nagiru::Output::NagiosFormatter do
  before(:each) do
    @formatter = Nagiru::Output::NagiosFormatter.new(String.new)
  end

  it "should provide a way to output a contact" do
    @formatter.should respond_to(:contact)
  end

  describe "formatting a contact" do
    before(:each) do
      @contact = Nagiru::Nagios::Contact.new(:email_address => "craig@barkingiguana.com", :name => "craig")
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

  it "should provide a way to output a host" do
    @formatter.should respond_to(:host)
  end

  describe "formatting a host" do
    before(:each) do
      @host = Nagiru::Nagios::Host.new(:address => "ducky.local", :name => "ducky", :alias => "Server Ducky")
    end

    it "should output 'define contact {' at the start" do
      @formatter.host(@host)
      # FIXME: This should have a custom rspec matcher for "match":
      #        first_line.should match(/^define\s+contact\s+\{/)
      first_line = @formatter.output.strip.split(/\n/)[0]
      if (first_line !~ /^\s*define\s+host\s*\{\s*$/)
        raise "Output should start with 'define host {'"
      end
    end

    it "should output '}' at the end" do
      @formatter.host(@host)
      # FIXME: This should have a custom rspec matcher for "match":
      #        last_line.should match(/^\s*\}\s*$/)
      last_line = @formatter.output.strip.split(/\n/)[-1]
      if (last_line !~ /^\s*\}\s*$/)
        raise "Output should end with '}'"
      end
    end

    it "should output the email address" do
      @formatter.host(@host)
      # FIXME: This should have a custom rspec matcher for "match":
      #        output.should match(/address\s+ducky\.local/)
      if (@formatter.output !~ /address\s+ducky\.local/)
        raise "Output should contain the address"
      end
    end

    it "should output the host name" do
      @formatter.host(@host)
      # FIXME: This should have a custom rspec matcher for "match":
      #        output.should match(/host\_name\s+ducky/)
      if (@formatter.output !~ /host\_name\s+ducky/)
        raise "Output should contain the host name"
      end
    end

    it "should output the alias" do
      @formatter.host(@host)
      # FIXME: This should have a custom rspec matcher for "match":
      #        output.should match(/host\_name\s+ducky/)
      if (@formatter.output !~ /alias\s+Server Ducky/)
        raise "Output should contain the alias"
      end
    end

    it "should output in a format that can be parsed back into a host object" do
      @formatter.host(@host)
      hosts = Nagiru::Nagios::Host.parse(@formatter.output)
      hosts[0].name.should eql(@host.name)
      hosts[0].address.should eql(@host.address)
      hosts[0].alias.should eql(@host.alias)
    end
  end
end