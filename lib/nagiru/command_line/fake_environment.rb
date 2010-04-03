module Nagiru
  module CommandLine
    class FakeEnvironment
      attr_reader :commands

      def initialize
        @commands = []
        @output_for = Hash.new do |hash, command|
          hash[command] = {
            :output => "Output for command '#{command}' not defined",
            :exit_code => 0
          }
        end
      end

      def output_for(command, output, exit_code = 0)
        @output_for[command].merge!(
          :output => output,
          :exit_code => exit_code
        )
      end

      def run(command)
        @commands << command
        @output_for[command][:output]
      end
    end
  end
end