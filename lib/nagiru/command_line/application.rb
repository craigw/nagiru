require File.join(File.dirname(__FILE__), '..', 'profile_manager')

module Nagiru
  module CommandLine
    class Application
      attr_accessor :arguments, :output
      def initialize(arguments = [], output = nil)
        self.arguments = arguments
        self.output = output || STDOUT
      end

      def execute
        manager, command, args = arguments
        case manager
        when /^profile$/i
          case command
          when /^create$/i
            profiles.create(args)
          when /^list$/
            profiles.each { |profile| output << "#{profile.name}\n" }
          when /^remove$/
            profiles.remove(args)
          else
            raise ArgumentError, "I'm not sure how to #{command} #{manager}s"
          end
        else
          raise ArgumentError, "I'm not sure how to manage #{manager}s"
        end
      end

      def profiles
        Nagiru::ProfileManager.new
      end
    end
  end
end
