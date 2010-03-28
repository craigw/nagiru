require 'nagiru/nagios/contact'

describe Nagiru::Nagios::Contact do
  it "should have an email address" do
    Nagiru::Nagios::Contact.new.should respond_to(:email_address)
  end

  it "should have a way to set the email address" do
    Nagiru::Nagios::Contact.new.should respond_to(:email_address=)
  end

  it "should have a name" do
    Nagiru::Nagios::Contact.new.should respond_to(:name)
  end

  it "should have a way to set the name" do
    Nagiru::Nagios::Contact.new.should respond_to(:name=)
  end

  describe "being instanciated" do 
    it "should assign the attributes from options when created" do
      options = { :name => "craig", :email_address => "craig@barkingiguana.com" }
      contact = Nagiru::Nagios::Contact.new(options)
      contact.name.should eql(options[:name])
      contact.email_address.should eql(options[:email_address])
    end
  end

  describe "being parsed from a string" do 
    describe "with only one contact" do
      before(:each) do
        @string = "define contact {\n"
        @string << "  contact_name craig\n"
        @string << "  email        craig@barkingiguana.com\n"
        @string << "}"
      end

      it "should return a collection containing of one contact" do
        contacts = Nagiru::Nagios::Contact.parse(@string)
        contacts.should have(1).contact
        contacts[0].should be_kind_of(Nagiru::Nagios::Contact)
      end

      it "should correctly load the name" do
        contacts = Nagiru::Nagios::Contact.parse(@string)
        contacts[0].name.should eql("craig")
      end

      it "should correctly load the email address" do
        contacts = Nagiru::Nagios::Contact.parse(@string)
        contacts[0].email_address.should eql("craig@barkingiguana.com")
      end
    end

    describe "with several contacts" do
      before(:each) do
        @string = "define contact {\n"
        @string << "  contact_name craig\n"
        @string << "  email        craig@barkingiguana.com\n"
        @string << "}\n"
        @string << "define contact {\n"
        @string << "  contact_name brian\n"
        @string << "  email        brian@example.net\n"
        @string << "}\n"
        @string << "define contact {\n"
        @string << "  contact_name dan\n"
        @string << "  email        dan@desperate.com\n"
        @string << "}\n"
      end

      it "should return a collection containing the correct number contacts" do
        contacts = Nagiru::Nagios::Contact.parse(@string)
        contacts.should have(3).contacts
        contacts.each do |contact|
          contact.should be_kind_of(Nagiru::Nagios::Contact)
        end
      end

      it "should correctly load the names" do
        contacts = Nagiru::Nagios::Contact.parse(@string)
        contacts.detect { |contact| contact.name == "craig" }.should_not be_nil
        contacts.detect { |contact| contact.name == "brian" }.should_not be_nil
        contacts.detect { |contact| contact.name == "dan" }.should_not be_nil
      end

      it "should correctly load the email addresses" do
        contacts = Nagiru::Nagios::Contact.parse(@string)
        contacts.detect { |contact| contact.email_address == "craig@barkingiguana.com" }.should_not be_nil
        contacts.detect { |contact| contact.email_address == "brian@example.net" }.should_not be_nil
        contacts.detect { |contact| contact.email_address == "dan@desperate.com" }.should_not be_nil
      end

      it "should associate the names and email addresses with the correct contacts" do
        contacts = Nagiru::Nagios::Contact.parse(@string)
        contacts.detect { |contact| contact.name == "craig" }.should_not be_nil
        contacts.detect { |contact| contact.name == "brian" }.should_not be_nil
        contacts.detect { |contact| contact.name == "dan" }.should_not be_nil
      end
    end
  end
end