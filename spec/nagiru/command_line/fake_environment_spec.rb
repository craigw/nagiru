require 'nagiru/command_line/fake_environment'

describe Nagiru::CommandLine::FakeEnvironment do
  before(:each) do
    @environment = Nagiru::CommandLine::FakeEnvironment.new
  end

  it "should record commands that are run" do
    command = "cowsay 'Hello, world!'"
    @environment.run(command)
    @environment.commands[-1].should eql(command)
  end

  it "should return the output we set for the commands" do
    command = "be_groovy"
    @environment.output_for(command, "Success")
    output = @environment.run(command)
    output.should eql("Success")
  end

  it "should freak out if the command returns an unexpected exit code" do
    command = "throw_exception"
    @environment.output_for(command, "Fail", 1)
    lambda {
      @command.run(command) 
    }.should raise_error
  end

  it "should record all commands in execution order" do
    commands = [ "cowsay 'Hello, world!'", "echo 'foo'", 'date' ]
    commands.each { |command| @environment.run(command) }
    recorded = @environment.commands
    recorded[0].should eql("cowsay 'Hello, world!'")
    recorded[1].should eql("echo 'foo'")
    recorded[2].should eql("date")
  end
end