module Nagiru
  module CommandLine
    class LiveEnvironment
      def run(command)
        output = IO.popen(command) { |io| io.read.to_s.strip }
        if $?.exitstatus == 0
          output
        else
          raise "#{command} exited with status #{$?.exitstatus}"
        end
      end
    end
  end
end