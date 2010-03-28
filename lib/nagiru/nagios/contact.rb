module Nagiru
  module Nagios
    class Contact
      attr_accessor :name, :email_address
      def initialize(options = {})
        options.each do |k, v|
          if respond_to?("#{k}=")
            send "#{k}=", v
          end
        end
      end

      def self.parse(string)
        contacts = string.scan(/.*define\s+contact\s*\{[^\}]*\}/)
        contacts.map do |contact|
          name = contact.scan(/contact\_name\s+([^\s]+)/m)[0].to_a[0].strip
          email_address = contact.scan(/email\s+([^\s]+)/m)[0].to_a[0].strip
          new :name => name, :email_address => email_address
        end
      end
    end
  end
end