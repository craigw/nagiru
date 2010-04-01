module Nagiru
  module Nagios
    class Host
      attr_accessor :name, :address, :alias
      def initialize(options = {})
        options.each do |k, v|
          if respond_to?("#{k}=")
            send "#{k}=", v
          end
        end
      end

      def self.parse(string)
        hosts = string.scan(/.*define\s+host\s*\{[^\}]*\}/)
        hosts.map do |host|
          name = host.scan(/host\_name\s+([^\s]+)/m)[0].to_a[0].strip
          address = host.scan(/address\s+([^\s]+)/m)[0].to_a[0].strip
          host_alias = host.scan(/alias\s+(.+)$/)[0].to_a[0].strip
          new :name => name, :address => address, :alias => host_alias
        end
      end
    end
  end
end