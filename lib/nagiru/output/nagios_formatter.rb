module Nagiru
  module Output
    class NagiosFormatter
      attr_accessor :output

      def initialize(output = nil)
        self.output = output || STDOUT
      end

      def contact(contact)
        output << "define contact {\n" +
        output << "  contact_name #{contact.name}\n" +
        output << "  email        #{contact.email_address}\n" +
        output << "}"
      end
    end
  end
end