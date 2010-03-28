require 'nagiru/nagios/host'

describe Nagiru::Nagios::Host do
  it "should have a name" do
    Nagiru::Nagios::Host.new.should respond_to(:name)
  end

  it "should have a way to set the name" do
    Nagiru::Nagios::Host.new.should respond_to(:name=)
  end

  it "should have an address" do
    Nagiru::Nagios::Host.new.should respond_to(:address)
  end

  it "should have a way to set the address" do
    Nagiru::Nagios::Host.new.should respond_to(:address=)
  end

  it "should have an alias" do
    Nagiru::Nagios::Host.new.should respond_to(:alias)
  end

  it "should have a way to set the alias" do
    Nagiru::Nagios::Host.new.should respond_to(:alias=)
  end

  describe "being instanciated" do 
    it "should assign the attributes from options when created" do
      options = { :name => "ducky", :address => "ducky.local", :alias => "Server Ducky" }
      host = Nagiru::Nagios::Host.new(options)
      host.name.should eql(options[:name])
      host.address.should eql(options[:address])
      host.alias.should eql(options[:alias])
    end
  end

  describe "being parsed from a string" do
    describe "with no hosts" do
      before(:each) do
        @string =  "define contact {\n"
        @string << "  contact_name craig\n"
        @string << "  email        craig@barkingiguana.com\n"
        @string << "}"
      end

      it "should return an empty collection" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.should be_empty
      end
    end

    describe "with only one host" do
      before(:each) do
        @string =  "define host {\n"
        @string << "  host_name ducky\n"
        @string << "  address   ducky.local\n"
        @string << "  alias     Server Ducky\n"
        @string << "}"
      end

      it "should return a collection containing one host" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.should have(1).host
        hosts[0].should be_kind_of(Nagiru::Nagios::Host)
      end

      it "should correctly load the name" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts[0].name.should eql("ducky")
      end

      it "should correctly load the address" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts[0].address.should eql("ducky.local")
      end

      it "should correctly load the alias" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts[0].alias.should eql("Server Ducky")
      end
    end

    describe "with several hosts" do
      before(:each) do
        @string =  "define host {\n"
        @string << "  host_name ducky\n"
        @string << "  address   ducky.local\n"
        @string << "  alias     Server Ducky\n"
        @string << "}"
        @string << "define host {\n"
        @string << "  host_name mouse\n"
        @string << "  address   mouse.local\n"
        @string << "  alias     Server Mouse\n"
        @string << "}"
        @string << "define host {\n"
        @string << "  host_name chicken\n"
        @string << "  address   chicken.local\n"
        @string << "  alias     Desktop Chicken\n"
        @string << "}"
      end

      it "should return a collection containing the correct number of hosts" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.should have(3).hosts
        hosts.each do |host|
          host.should be_kind_of(Nagiru::Nagios::Host)
        end
      end

      it "should correctly load the names" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.name == "ducky" }.should_not be_nil
        hosts.detect { |host| host.name == "mouse" }.should_not be_nil
        hosts.detect { |host| host.name == "chicken" }.should_not be_nil
      end

      it "should correctly load the addresses" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.address == "ducky.local" }.should_not be_nil
        hosts.detect { |host| host.address == "mouse.local" }.should_not be_nil
        hosts.detect { |host| host.address == "chicken.local" }.should_not be_nil
      end

      it "should correctly load the aliases" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.alias == "Server Ducky" }.should_not be_nil
        hosts.detect { |host| host.alias == "Server Mouse" }.should_not be_nil
        hosts.detect { |host| host.alias == "Desktop Chicken" }.should_not be_nil
      end


      it "should associate the names, addresses and aliases with the correct hosts" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.name == "ducky" && host.address == "ducky.local" && host.alias == "Server Ducky" }.should_not be_nil
        hosts.detect { |host| host.name == "mouse" && host.address == "mouse.local" && host.alias == "Server Mouse" }.should_not be_nil
        hosts.detect { |host| host.name == "chicken" && host.address == "chicken.local" && host.alias == "Desktop Chicken" }.should_not be_nil
      end
    end

    describe "with several hosts and several other objects" do
      before(:each) do
        @string =  "define host {\n"
        @string << "  host_name chicken\n"
        @string << "  address   chicken.local\n"
        @string << "  alias     Desktop Chicken\n"
        @string << "}"
        @string << "define contact {\n"
        @string << "  contact_name brian\n"
        @string << "  email        brian@example.net\n"
        @string << "}\n"
        @string << "define service {\n"
        @string << "  name HTTP\n"
        @string << "  hostname chicken\n"
        @string << "}\n"
        @string << "define host {\n"
        @string << "  host_name mouse\n"
        @string << "  address   mouse.local\n"
        @string << "  alias     Server Mouse\n"
        @string << "}"
      end

      it "should return a collection containing the correct number of hosts" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.should have(2).hosts
        hosts.each do |host|
          host.should be_kind_of(Nagiru::Nagios::Host)
        end
      end

      it "should correctly load the names" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.name == "chicken" }.should_not be_nil
        hosts.detect { |host| host.name == "mouse" }.should_not be_nil
      end

      it "should correctly load the email addresses" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.address == "chicken.local" }.should_not be_nil
        hosts.detect { |host| host.address == "mouse.local" }.should_not be_nil
      end

      it "should correctly load the aliases" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.alias == "Desktop Chicken" }.should_not be_nil
        hosts.detect { |host| host.alias == "Server Mouse" }.should_not be_nil
      end

      it "should associate the names, addresses and aliases with the correct hosts" do
        hosts = Nagiru::Nagios::Host.parse(@string)
        hosts.detect { |host| host.name == "chicken" && host.address == "chicken.local" && host.alias == "Desktop Chicken" }.should_not be_nil
        hosts.detect { |host| host.name == "mouse" && host.address == "mouse.local" && host.alias == "Server Mouse" }.should_not be_nil
      end
    end
  end
end