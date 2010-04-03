require 'nagiru/command_line/live_environment'

module Nagiru
  module CommandLine
    class Command
      attr_accessor :execution_environment
      attr_reader :arguments, :output

      def initialize(command_name = "nagiru", parent_command = nil, execution_environment = nil)
        @parent_command = parent_command
        @command_name = command_name.to_s
        execution_environment ||= Nagiru::CommandLine::LiveEnvironment.new
        self.execution_environment = execution_environment
        self.arguments = []
      end

      def command_line
        command =  @parent_command ? @parent_command.command_line + ' ' : ''
        command << @command_name
        command_arguments = arguments.dup
        while argument = command_arguments.shift
          if argument.respond_to?(:keys)
            flags = argument.keys
            while flag = flags.shift
              command << " --#{flag} #{argument[flag]}"
            end
          else
            command << " #{argument}"
          end
        end
        command
      end

      def execute
        self.output = execution_environment.run(command_line)
      end

      def output=(output)
        @output = output
        @parent_command.output = output if @parent_command
      end

      def arguments=(*args)
        @arguments = args.flatten
      end

      def method_missing(sub_command, *sub_arguments)
        command = self.class.new sub_command, self, execution_environment
        command.arguments = sub_arguments
        command
      end
    end
  end
end