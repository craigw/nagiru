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
    before(:each) do
      @string = "define contact {\n"
      @string << "  contact_name craig\n"
      @string << "  email        craig@barkingiguana.com\n"
      @string << "}"
    end

    it "should correctly load the name" do
      contact = Nagiru::Nagios::Contact.new(@string)
      contact.name.should eql("craig")
    end

    it "should correctly load the email address" do
      contact = Nagiru::Nagios::Contact.new(@string)
      contact.email_address.should eql("craig@barkingiguana.com")
    end
  end
end