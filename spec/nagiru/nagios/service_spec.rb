require 'nagiru/nagios/service'

describe Nagiru::Nagios::Service do
  it "should have a name" do
    Nagiru::Nagios::Service.new.should respond_to(:host_name)
  end

  it "should have a way to set the name" do
    Nagiru::Nagios::Service.new.should respond_to(:host_name=)
  end

  it "should have an address" do
    Nagiru::Nagios::Service.new.should respond_to(:description)
  end

  it "should have a way to set the address" do
    Nagiru::Nagios::Service.new.should respond_to(:description=)
  end

  it "should have an contact_groups" do
    Nagiru::Nagios::Service.new.should respond_to(:check_command)
  end

  it "should have a way to set the contact_groups" do
    Nagiru::Nagios::Service.new.should respond_to(:check_command=)
  end

  it "should have an contact_groups" do
    Nagiru::Nagios::Service.new.should respond_to(:contact_groups)
  end

  it "should have a way to set the contact_groups" do
    Nagiru::Nagios::Service.new.should respond_to(:contact_groups=)
  end

  describe "being instanciated" do 
    it "should assign the attributes from options when created" do
      options = { :host_name => "ducky", :description => "ducky.local",
                  :check_command => "Server Ducky",
                  :contact_groups => %W(sysadmin others) }
      service = Nagiru::Nagios::Service.new(options)
      service.host_name.should eql(options[:host_name])
      service.description.should eql(options[:description])
      service.check_command.should eql(options[:check_command])
      service.contact_groups.should eql(options[:contact_groups])
    end
  end

  describe "being parsed from a string" do
    describe "with no services" do
      before(:each) do
        @string =  "define contact {\n"
        @string << "  contact_name craig\n"
        @string << "  email        craig@barkingiguana.com\n"
        @string << "}"
      end

      it "should return an empty collection" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.should be_empty
      end
    end

    describe "with only one service" do
      before(:each) do
        @string =  "define service {\n"
        @string << "  host_name           ducky\n"
        @string << "  service_description HTTP\n"
        @string << "  check_command       check_http\n"
        @string << "  contact_groups      craig, sysadmin, others\n"
        @string << "}"
      end

      it "should return a collection containing one service" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.should have(1).service
        services.each do |svc|
          svc.should be_kind_of(Nagiru::Nagios::Service)
        end
      end

      it "should correctly load the host_names" do
        services = Nagiru::Nagios::Service.parse(@string)
        services[0].host_name.should eql("ducky")
      end

      it "should correctly load the descriptions" do
        services = Nagiru::Nagios::Service.parse(@string)
        services[0].description.should eql("HTTP")
      end

      it "should correctly load the check_commands" do
        services = Nagiru::Nagios::Service.parse(@string)
        services[0].check_command.should eql("check_http")
      end

      it "should correctly load the contact_groups" do
        contact_groups = %W(sysadmin craig others).sort
        services = Nagiru::Nagios::Service.parse(@string)
        services[0].contact_groups.sort.should eql(contact_groups)
      end
    end

    describe "with several services" do
      before(:each) do
        @string =  "define service {\n"
        @string << "  host_name           chicken\n"
        @string << "  service_description HTTP\n"
        @string << "  check_command       check_http\n"
        @string << "  contact_groups      sysadmin, craig\n"
        @string << "}"
        @string << "define service {\n"
        @string << "  host_name           mouse\n"
        @string << "  service_description DNS\n"
        @string << "  check_command       check_dns\n"
        @string << "  contact_groups      craig\n"
        @string << "}"
        @string << "define service {\n"
        @string << "  host_name           ducky\n"
        @string << "  service_description SMTP\n"
        @string << "  check_command       check_smtp\n"
        @string << "  contact_groups      craig, sysadmin, others\n"
        @string << "}"
      end

      it "should return a collection containing the correct number of services" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.should have(3).services
        services.each do |svc|
          svc.should be_kind_of(Nagiru::Nagios::Service)
        end
      end

      it "should correctly load the host_names" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.host_name == "chicken" }.should_not be_nil
        services.detect { |svc| svc.host_name == "mouse" }.should_not be_nil
        services.detect { |svc| svc.host_name == "ducky" }.should_not be_nil
      end

      it "should correctly load the descriptions" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.description == "HTTP" }.should_not be_nil
        services.detect { |svc| svc.description == "DNS" }.should_not be_nil
        services.detect { |svc| svc.description == "SMTP" }.should_not be_nil
      end

      it "should correctly load the check_commands" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.check_command == "check_http" }.should_not be_nil
        services.detect { |svc| svc.check_command == "check_dns" }.should_not be_nil
        services.detect { |svc| svc.check_command == "check_smtp" }.should_not be_nil
      end

      it "should correctly load the contact_groups" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.contact_groups.sort == %W(sysadmin craig others).sort }.should_not be_nil
        services.detect { |svc| svc.contact_groups.sort == %W(sysadmin craig).sort }.should_not be_nil
        services.detect { |svc| svc.contact_groups.sort == %W(craig).sort }.should_not be_nil
      end

      it "should associate the host_name, description and check_command and contact_groups with the correct services" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.host_name == "chicken" && svc.description == "HTTP" && svc.check_command == "check_http" && svc.contact_groups.sort == %W(sysadmin craig).sort }.should_not be_nil
        services.detect { |svc| svc.host_name == "mouse"   && svc.description == "DNS"  && svc.check_command == "check_dns"  && svc.contact_groups.sort == %W(craig).sort }.should_not be_nil
        services.detect { |svc| svc.host_name == "ducky"   && svc.description == "SMTP" && svc.check_command == "check_smtp" && svc.contact_groups.sort == %W(craig sysadmin others).sort }.should_not be_nil
      end
    end

    describe "with several services and several other objects" do
      before(:each) do
        @string =  "define service {\n"
        @string << "  host_name           chicken\n"
        @string << "  service_description HTTP\n"
        @string << "  check_command       check_http\n"
        @string << "  contact_groups      sysadmin, craig\n"
        @string << "}"
        @string << "define contact {\n"
        @string << "  contact_name brian\n"
        @string << "  email        brian@example.net\n"
        @string << "}\n"
        @string << "define service {\n"
        @string << "  host_name           mouse\n"
        @string << "  service_description DNS\n"
        @string << "  check_command       check_dns\n"
        @string << "  contact_groups      craig\n"
        @string << "}"
        @string << "define host {\n"
        @string << "  host_name mouse\n"
        @string << "  address   mouse.local\n"
        @string << "  alias     Server Mouse\n"
        @string << "}"
      end

      it "should return a collection containing the correct number of services" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.should have(2).services
        services.each do |svc|
          svc.should be_kind_of(Nagiru::Nagios::Service)
        end
      end

      it "should correctly load the host_names" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.host_name == "chicken" }.should_not be_nil
        services.detect { |svc| svc.host_name == "mouse" }.should_not be_nil
      end

      it "should correctly load the descriptions" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.description == "HTTP" }.should_not be_nil
        services.detect { |svc| svc.description == "DNS" }.should_not be_nil
      end

      it "should correctly load the check_commands" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.check_command == "check_http" }.should_not be_nil
        services.detect { |svc| svc.check_command == "check_dns" }.should_not be_nil
      end

      it "should correctly load the contact_groups" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.contact_groups.sort == %W(craig).sort }.should_not be_nil
        services.detect { |svc| svc.contact_groups.sort == %W(sysadmin craig).sort }.should_not be_nil
      end

      it "should associate the host_name, description and check_command and contact_groups with the correct services" do
        services = Nagiru::Nagios::Service.parse(@string)
        services.detect { |svc| svc.host_name == "chicken" && svc.description == "HTTP" && svc.check_command == "check_http" && svc.contact_groups.sort == %W(sysadmin craig).sort }.should_not be_nil
        services.detect { |svc| svc.host_name == "mouse"   && svc.description == "DNS"  && svc.check_command == "check_dns"  && svc.contact_groups.sort == %W(craig).sort }.should_not be_nil
      end
    end
  end
end