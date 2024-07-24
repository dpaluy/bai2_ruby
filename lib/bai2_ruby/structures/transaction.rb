# frozen_string_literal: true

module BAI2
  module Structures
    class Transaction
      attr_reader :type, :amount, :funds_type, :availability, :bank_reference, :customer_reference, :text

      def initialize(type:, amount:, funds_type:, availability:, bank_reference:, customer_reference:, text:)
        @type = type
        @amount = amount
        @funds_type = funds_type
        @availability = availability
        @bank_reference = bank_reference
        @customer_reference = customer_reference
        @text = text
      end
    end
  end
end
