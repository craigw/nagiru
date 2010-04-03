require 'nagiru/profile'

describe Nagiru::Profile do
  it "should have a way of getting the name" do
    profile = Nagiru::Profile.new
    profile.should respond_to(:name)
  end

  it "should have a way of setting the name" do
    profile = Nagiru::Profile.new
    profile.should respond_to(:name=)
  end

  it "should set the name from the options passed when it's instanciated" do
    profile = Nagiru::Profile.new :name => "lamp-example"
    profile.name.should eql("lamp-example")
  end
end