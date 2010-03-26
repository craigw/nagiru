module Nagiru
  module Nagios
    class Contact
      attr_accessor :name, :email_address
      def initialize(source = {})
        if source.kind_of?(Hash)
          update(source)
        else
          parse(source)
        end
      end

      private
      def update(options)
        options.each do |k, v|
          if respond_to?("#{k}=")
            send "#{k}=", v
          end
        end
      end

      def parse(string)
        self.name = string.scan(/contact\_name\s+([^\s]+)/m)[0].to_a[0]
        self.email_address = string.scan(/email\s+([^\s]+)/m)[0].to_a[0]
      end
    end
  end
end