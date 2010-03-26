module Nagiru
  module Output
    class NagiosFormatter
      def contact(contact)
        "define contact {\n" +
        "  contact_name #{contact.name}\n" +
        "  email        #{contact.email_address}\n" +
        "}"
      end
    end
  end
end