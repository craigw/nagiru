module Nagiru
  module Nagios
    class Service
      attr_accessor :host_name, :description, :check_command, :contact_groups
      def initialize(options = {})
        options.each do |k, v|
          if respond_to?("#{k}=")
            send "#{k}=", v
          end
        end
      end

      def self.parse(string)
        services = string.scan(/.*define\s+service\s*\{[^\}]*\}/)
        services.map do |service|
          host_name = service.scan(/host\_name\s+([^\s]+)/m)[0].to_a[0].strip
          description = service.scan(/description\s+([^\s]+)/m)[0].to_a[0].strip
          check_command = service.scan(/check\_command\s+([^\s]+)/m)[0].to_a[0].strip
          contact_groups = service.scan(/contact\_groups\s+(.*)$/)[0].to_a[0].strip.split(/,/).map{|s|s.strip}
          new :host_name => host_name,
              :description => description,
              :check_command => check_command,
              :contact_groups => contact_groups
        end

      end
    end
  end
end