require 'nagiru/profile_manager'
require 'ftools'

describe Nagiru::ProfileManager do
  it "should be able to remove profiles" do
    pm = Nagiru::ProfileManager.new
    pm.should respond_to(:remove)
  end

  describe "removing profiles" do
    before(:each) do
      @pm = Nagiru::ProfileManager.new
      @pm.create("example-to-remove")
    end

    it "should remove the profile directory" do
      root = File.join(File.dirname(__FILE__), '..', '..')
      profile_dir = File.join(root, 'nagiru', 'profiles', "example-to-remove")
      File.directory?(profile_dir).should be_true
      @pm.remove("example-to-remove")
      File.directory?(profile_dir).should be_false
    end
  end

  it "should be able to create profiles" do
    pm = Nagiru::ProfileManager.new
    pm.should respond_to(:create)
  end

  describe "creating a profile" do
    before(:each) do
      @pm = Nagiru::ProfileManager.new
    end

    it "should create a directory for the profile" do
      @pm.create("example-profile")
      root = File.join(File.dirname(__FILE__), '..', '..')
      profile_dir = File.join(root, 'nagiru', 'profiles', "example-profile")
      File.directory?(profile_dir).should be_true
    end

    it "should create nagios.cfg for the profile" do
      @pm.create("example-profile")
      root = File.join(File.dirname(__FILE__), '..', '..')
      profile_dir = File.join(root, 'nagiru', 'profiles', "example-profile")
      nagios_cfg = File.join(profile_dir, 'nagios.cfg')
      File.should exist(nagios_cfg)
    end

    after(:each) do
      root = File.join(File.dirname(__FILE__), '..', '..')
      profile_dir = File.join(root, 'nagiru', 'profiles', "example-profile")
      @pm.remove("example-profile")
    end
  end

  it "should allow mapping over all profiles" do
    pm = Nagiru::ProfileManager.new
    pm.should respond_to(:map)
  end
  
  describe "mapping over all profiles" do
    before(:each) do
      @pm = Nagiru::ProfileManager.new
      @pm.each do |profile|
        @pm.remove(profile.name)
      end
      @pm.create("map-test")
    end

    it "should call the passed block for each profile and return the results" do
      names = @pm.map { |profile| profile.name }
      names.should have(1).name
      names[0].should eql("map-test")
    end

    after(:each) do
      @pm.remove("map-test")
    end
  end

  it "should allow iterating over all profiles" do
    pm = Nagiru::ProfileManager.new
    pm.should respond_to(:each)
  end
  
  describe "iterating over all profiles" do
    before(:each) do
      @pm = Nagiru::ProfileManager.new
      @pm.each do |profile|
        @pm.remove(profile.name)
      end
      @pm.create("each-test")
    end

    it "should call the passed block for each profile" do
      names = []
      @pm.each { |profile| names << profile.name }
      names.should have(1).name
      names[0].should eql("each-test")
    end

    after(:each) do
      @pm.remove("each-test")
    end
  end
end