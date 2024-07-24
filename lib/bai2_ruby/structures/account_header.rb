# frozen_string_literal: true

module BAI2
  module Structures
    class AccountHeader
      attr_reader :customer_account_number, :currency_code, :type_code

      def initialize(customer_account_number:, currency_code:, type_code:)
        @customer_account_number = customer_account_number
        @currency_code = currency_code
        @type_code = type_code
      end
    end
  end
end
