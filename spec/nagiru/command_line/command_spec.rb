require 'nagiru/command_line/command'
require 'nagiru/command_line/fake_environment'
require 'nagiru/command_line/live_environment'

shared_examples_for "a regular command" do
  it "should return a command" do
    @command.should be_kind_of(Nagiru::CommandLine::Command)
  end

  it "should be executable" do
    @command.should respond_to(:execute)
  end

  it "should have a way to set arguments" do
    @command.should respond_to(:arguments)
  end

  describe "which is executed" do
    before(:each) do
      @command.execution_environment = Nagiru::CommandLine::FakeEnvironment.new
    end

    it "should run the command in the execution environment" do
      @command.execute
      last_command = @command.execution_environment.commands[-1]
      last_command.should eql(@command.command_line)
    end

    it "should return the output of the command" do
      env = @command.execution_environment
      env.output_for(@command.command_line, "Yes")
      output = @command.execute
      output.should eql("Yes")
    end

    it "should store the last output" do
      env = @command.execution_environment
      env.output_for(@command.command_line, "Chickens")
      @command.execute
      @command.output.should eql("Chickens")
    end

    it "should propagate output to the parent command when executed" do
      sub_command = @command.alpha.beta.gamma
      env = @command.execution_environment
      env.output_for(sub_command.command_line, "Ducks")
      sub_command.execute
      @command.output.should eql("Ducks")
    end
  end
end

shared_examples_for "a command" do
  describe "building a sub-command" do
    it "should set the correct execution environment" do
      @execution_environment = Nagiru::CommandLine::FakeEnvironment
      @command.execution_environment = @execution_environment
      @command.test.execution_environment.should eql(@execution_environment)
    end

    describe "without arguments" do
      before(:each) do
        @command_line = @command.command_line
        @command = @command.test
      end

      it_should_behave_like "a regular command"

      it "should add the sub-command to it's command line to" do
        @command.command_line.should eql("#{@command_line} test")
      end
    end

    describe "with arguments" do
      before(:each) do
        @command_line = @command.command_line
        @command = @command.test.run(:all, :switch => "alternate")
      end

      it_should_behave_like "a regular command"

      it "should add the sub-command and arguments to it's command line" do
        @command.command_line.should eql("#{@command_line} test run all --switch alternate")
      end
    end
  end
end

describe Nagiru::CommandLine::Command do
  before(:each) do
    @command = Nagiru::CommandLine::Command.new
  end

  it "should normally execute in the live environment" do
    @command.execution_environment.should be_kind_of(Nagiru::CommandLine::LiveEnvironment)
  end

  it "should be able to respresent itself as a command line" do
    @command.command_line.should eql("nagiru")
  end

  describe "with arguments" do
    before(:each) do
      @command.arguments = { :profile => "lamp" }
    end

    it "should represent the arguments in the command line" do
      @command.command_line.should eql("nagiru --profile lamp")
    end

    it_should_behave_like "a command"
  end

  it_should_behave_like "a command"
end