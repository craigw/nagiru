require 'nagiru/command_line/application'

describe Nagiru::CommandLine::Application do
  it "should have a way of setting the arguments" do
    application = Nagiru::CommandLine::Application.new
    application.should respond_to(:arguments=)
  end

  it "should have a way of setting the arguments" do
    application = Nagiru::CommandLine::Application.new
    application.should respond_to(:arguments=)
  end

  it "should have a way of getting the arguments" do
    application = Nagiru::CommandLine::Application.new
    application.should respond_to(:arguments)
  end

  describe "being instanciated" do
    it "should accept arguments as arguments to the new method" do
      sample = %W(foo bar baz quux)
      application = Nagiru::CommandLine::Application.new(sample)
      application.arguments.should eql(sample)
    end

    it "shouldn't require arguments" do
      new_application = lambda { Nagiru::CommandLine::Application.new }
      new_application.should_not raise_exception
    end
  end

  it "should have a way of managing the profiles" do
    application = Nagiru::CommandLine::Application.new
    application.should respond_to(:profiles)
    application.profiles.should be_kind_of(Nagiru::ProfileManager)
  end

  it "should have a way of setting the output receiver" do
    application = Nagiru::CommandLine::Application.new
    application.should respond_to(:output)
    application.should respond_to(:output=)
  end

  it "should output to STDOUT by default" do
    application = Nagiru::CommandLine::Application.new
    application.output.should eql(STDOUT)
  end

  it "should optionally take the output receiver as the second argument when initialising" do
    example = Object.new
    application = Nagiru::CommandLine::Application.new([], example)
    application.output.should eql(example)
  end

  it "should have a way of being executed" do
    application = Nagiru::CommandLine::Application.new
    application.should respond_to(:execute)
  end

  describe "being executed" do
    describe "with a manager that doesn't exist" do
      before(:each) do
        argv = %W(profiles create bunny) # profiles is wrong - should be profile
        @application = Nagiru::CommandLine::Application.new(argv)
      end

      it "should raise an ArgumentError" do
        lambda {
          @application.execute
        }.should raise_exception(ArgumentError)
      end
    end

    describe "with a command that doesn't exist" do
      before(:each) do
        argv = %W(profile add bunny) # Add is wrong - should be create
        @application = Nagiru::CommandLine::Application.new(argv)
      end

      it "should raise an ArgumentError" do
        lambda {
          @application.execute
        }.should raise_exception(ArgumentError)
      end
    end

    describe "removing profiles" do
      before(:each) do
        argv = %W(profile remove tasty-chicken)
        buffer = ""
        @application = Nagiru::CommandLine::Application.new(argv, buffer)
        profiles = @application.profiles
        profiles.each do |profile|
          profiles.remove(profile.name)
        end
        @application.profiles.create("tasty-chicken")
      end

      it "should run without error" do
        lambda {
          @application.execute
        }.should_not raise_exception
      end

      it "should remove the profile" do
        @application.profiles.detect { |p| p.name == "tasty-chicken" }.should_not be_nil
        @application.execute
        @application.profiles.detect { |p| p.name == "tasty-chicken" }.should be_nil
      end

      after(:each) do
        profiles = @application.profiles
        profiles.each do |profile|
          profiles.remove(profile.name)
        end
      end
    end

    describe "listing profiles" do
      before(:each) do
        argv = %W(profile list)
        buffer = ""
        @application = Nagiru::CommandLine::Application.new(argv, buffer)
        profiles = @application.profiles
        profiles.each do |profile|
          profiles.remove(profile.name)
        end
        @application.profiles.create("test1")
        @application.profiles.create("test2")
        @application.profiles.create("test3")
      end

      it "should list all profiles in alphabetical order" do
        @application.execute
        @application.output.split(/\n/).should eql(%W(test1 test2 test3))
      end

      after(:each) do
        profiles = @application.profiles
        profiles.each do |profile|
          profiles.remove(profile.name)
        end
      end
    end

    describe "creating a profile" do
      before(:each) do
        argv = %W(profile create bunny)
        @application = Nagiru::CommandLine::Application.new(argv)
      end

      describe "for the first time" do
        before(:each) do
          profiles = @application.profiles
          profiles.each do |profile|
            profiles.remove(profile.name)
          end
        end

        it "should add the new profile" do
          @application.execute
          profile_names = @application.profiles.map{ |p| p.name }
          profile_names.should include("bunny")
        end

        after(:each) do
          profiles = @application.profiles
          profiles.each do |profile|
            profiles.remove(profile.name)
          end
        end
      end

      # The stories don't yet ask for these.
      #
      # describe "where a profile with the same name exists" do
      #   it "should prompt to remove the old profile"
      #   describe "and it should be removed" do
      #     it "should remove the old profile"
      #     it "should add the new profile"
      #   end
      # 
      #   describe "and it should be kept" do
      #     it "should not do anything"
      #   end
      # end
    end
  end
end