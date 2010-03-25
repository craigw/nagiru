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

  it "should assign the attributes from options when created" do
    options = { :name => "craig", :email_address => "craig@barkingiguana.com" }
    contact = Nagiru::Nagios::Contact.new(options)
    contact.name.should eql(options[:name])
    contact.email_address.should eql(options[:email_address])
  end

  it "should be exportable to a string" do
    options = { :name => "craig", :email_address => "craig@barkingiguana.com" }
    contact = Nagiru::Nagios::Contact.new(options)
    desired = "define contact {\n"
    desired << "  contact_name #{options[:name]}\n"
    desired << "  email        #{options[:email_address]}\n"
    desired << "}"
    contact.to_s.should eql(desired)
  end
end