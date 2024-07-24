# frozen_string_literal: true

module BAI2
  module Structures
    class GroupTrailer
      attr_reader :group_control_total, :number_of_accounts, :number_of_records

      def initialize(group_control_total:, number_of_accounts:, number_of_records:)
        @group_control_total = group_control_total
        @number_of_accounts = number_of_accounts
        @number_of_records = number_of_records
      end
    end
  end
end
