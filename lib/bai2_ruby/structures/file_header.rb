# frozen_string_literal: true

module BAI2
  module Structures
    class FileHeader
      attr_reader :sender_id, :receiver_id, :file_creation_date, :file_creation_time,
                  :file_id, :physical_record_length, :block_size, :version_number

      def initialize(sender_id:, receiver_id:, file_creation_date:, file_creation_time:,
                     file_id:, physical_record_length:, block_size:, version_number:)
        @sender_id = sender_id
        @receiver_id = receiver_id
        @file_creation_date = file_creation_date
        @file_creation_time = file_creation_time
        @file_id = file_id
        @physical_record_length = physical_record_length
        @block_size = block_size
        @version_number = version_number
      end
    end
  end
end
