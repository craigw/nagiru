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

      def to_s
        s = "define contact {\n"
        s << "  contact_name #{name}\n"
        s << "  email        #{email_address}\n"
        s << "}"
      end
    end
  end
end