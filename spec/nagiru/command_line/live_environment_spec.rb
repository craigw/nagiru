require 'nagiru/command_line/live_environment'

describe Nagiru::CommandLine::LiveEnvironment do
  before(:each) do
    @environment = Nagiru::CommandLine::LiveEnvironment.new
  end

  it "should return the output of the command" do
    command = "echo 'Hello'"
    output = @environment.run(command)
    output.should eql("Hello")
  end

  it "should freak out if the command exits with a non-zero exit code" do
    command = "ruby -e 'exit 1'"
    lambda {
      @environment.run(command)
    }.should raise_error
  end
end