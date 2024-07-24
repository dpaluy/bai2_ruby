# frozen_string_literal: true

module BAI2
  module Structures
    class FileTrailer
      attr_reader :file_control_total, :number_of_groups, :number_of_records

      def initialize(file_control_total:, number_of_groups:, number_of_records:)
        @file_control_total = file_control_total
        @number_of_groups = number_of_groups
        @number_of_records = number_of_records
      end
    end
  end
end
