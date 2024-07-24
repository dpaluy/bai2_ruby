# frozen_string_literal: true

module BAI2
  module Structures
    class AccountTrailer
      attr_reader :account_control_total, :number_of_records

      def initialize(account_control_total:, number_of_records:)
        @account_control_total = account_control_total
        @number_of_records = number_of_records
      end
    end
  end
end
