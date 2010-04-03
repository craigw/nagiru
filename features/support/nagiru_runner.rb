require 'nagiru/command_line/command'

module NagiruRunner
  def nagiru
    @nagiru ||= begin
      # Make sure we're using the local copy of Nagiru by providing the full
      # path to the script.
      bin_dir = File.join(File.dirname(__FILE__), '..', '..', 'bin')
      nagiru_bin = File.expand_path(File.join(bin_dir, 'nagiru'))
      ::Nagiru::CommandLine::Command.new(nagiru_bin)
    end
  end
end

World(NagiruRunner)